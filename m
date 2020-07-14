Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF52E220013
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgGNVel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:34:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57836 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgGNVel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:34:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELMOMe037789;
        Tue, 14 Jul 2020 21:34:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=NhFeMOhEjtJNmf+mm1W0nJlhDypNc6cyJ6Wlqj1py/Y=;
 b=TaOR+oaScL7mnYiFvcGIwU1rnMKRpt4uDPsPOnORfmlbd1KqR6ZuLk1RbMCTKyhlLQ1o
 2szTpBewh8qVlEv/ET/W/AaaIsesYhd/po+e0qGCH3Bn8pR12iu5IiXx3vf6KEOPGDF8
 +AWnt4JyzZIF79pOWSoJp45gvt2B677FyFuLed0FRVfdqnqiffzP//zDDlyNvKMMssbZ
 7ThB3NtD/dtd1kI7CINdDX5qnh0If72jjo0zPTMit6gvS1uBVWnHjg2For2XwYLY3eOs
 Ej2PpTdjiGP5HLAwdonAJb4bCl7VObfsC0gUo3So+FTJ7TGbS0KErS/1q46jPngRr6vc 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3274ur81jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 21:34:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELJbDl161896;
        Tue, 14 Jul 2020 21:34:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 327qb5at24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 21:34:35 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06ELYZka020046;
        Tue, 14 Jul 2020 21:34:35 GMT
Received: from [10.39.221.185] (/10.39.221.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 14:34:35 -0700
Subject: Re: [PATCH 1/1] ax88172a: fix ax88172a_unbind() failures
To:     David Miller <davem@davemloft.net>, dan.carpenter@oracle.com
Cc:     kuba@kernel.org, dhaval.giani@oracle.com, netdev@vger.kernel.org
References: <1594641537-1288-1-git-send-email-george.kennedy@oracle.com>
 <20200713.170859.794084104671494668.davem@davemloft.net>
 <20200714080038.GX2571@kadam>
 <20200714.140323.590389609923321569.davem@davemloft.net>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
Message-ID: <b7423f65-53d5-35d7-a469-509163c85853@oracle.com>
Date:   Tue, 14 Jul 2020 17:34:33 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200714.140323.590389609923321569.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=2 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=2 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/14/2020 5:03 PM, David Miller wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Date: Tue, 14 Jul 2020 11:00:38 +0300
>
>> On Mon, Jul 13, 2020 at 05:08:59PM -0700, David Miller wrote:
>>> From: George Kennedy <george.kennedy@oracle.com>
>>> Date: Mon, 13 Jul 2020 07:58:57 -0400
>>>
>>>> @@ -237,6 +237,8 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
>>>>   
>>>>   free:
>>>>   	kfree(priv);
>>>> +	if (ret >= 0)
>>>> +		ret = -EIO;
>>>>   	return ret;
>>> Success paths reach here, so ">= 0" is not appropriate.  Maybe you
>>> meant "> 0"?
>> No, the success path is the "return 0;" one line before the start of the
>> diff.  This is always a failure path.
> Is zero ever a possibility, therefore?
>
> You have two cases, one with an explicit -EIO and another which jumps
> here "if (ret)"
>
> So it seems the answer is no.
The "free:" label is the failure path. The "free:" label can be gotten 
to with "ret" >= 0, but the failure path must exit with ret < 0 for 
proper failure cleanup.

For example, the failing case here has "ret" = 0 (#define ETH_ALEN 6):

     172 static int ax88172a_bind(struct usbnet *dev, struct 
usb_interface *intf)
     173 {
...
     186         /* Get the MAC address */
     187         ret = asix_read_cmd(dev, AX_CMD_READ_NODE_ID, 0, 0, 
ETH_ALEN, buf, 0);
     188         if (ret < ETH_ALEN) {
     189                 netdev_err(dev->net, "Failed to read MAC 
address: %d\n", ret);
     190                 goto free;
     191         }
"drivers/net/usb/ax88172a.c"

The caller to ax88172a_bind() is usbnet_probe() and in the case of 
failure, it needs the return value to be < 0.

    1653 int
    1654 usbnet_probe (struct usb_interface *udev, const struct 
usb_device_id *prod)
    1655 {
...
    1736         if (info->bind) {
    1737                 status = info->bind (dev, udev);
    1738                 if (status < 0)
    1739                         goto out1;
"drivers/net/usb/usbnet.c"

George

