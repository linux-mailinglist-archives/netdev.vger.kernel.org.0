Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B820A31BAD2
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 15:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhBOOQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 09:16:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45736 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhBOOQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 09:16:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11FEDXDw144674;
        Mon, 15 Feb 2021 14:15:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3gNGyOhW9S7vVwb8D9dPmez5jNnhd+voFLYDaiCGsJs=;
 b=itnRkjM91fYLnQ1DvuhOGeqsUSSZXu4I9j26HeslsGw0Bd+DrWqN8eONfTSX0nLZD3vW
 3YoJCMlYRUdZ2BEqAW5wuh/WeOVkaprFJwf1uhEFsqgMjiV87LwADAs398tuVWWwLzjp
 tT5NcfN1sPODhojFnXBZ4UiWCvMrMP970RsTtk5nW1wp9mFf7X+UhGOYbcWXnPJaJqcw
 FxE6iw7qoV2FnqHl3SzTFoZ/6mtO/XjUthrUycl9rQBhPcxNyJqno0lQj9+gdHy9FvAU
 Upk1POFHSUXuYk9jld9Ny7X6f2aXCz+757w2zVxwrZ33l6CxBVIuch4HucnnWvaOvf0a jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9a3nht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 14:15:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11FE5uHu139385;
        Mon, 15 Feb 2021 14:15:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 36prpvn689-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 14:15:35 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11FEFVaO026342;
        Mon, 15 Feb 2021 14:15:31 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Feb 2021 06:15:30 -0800
Date:   Mon, 15 Feb 2021 17:15:21 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kbuild@lists.01.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        lkp@intel.com, kbuild-all@lists.01.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 09/12] net: dsa: tag_ocelot: create separate
 tagger for Seville
Message-ID: <20210215141521.GC2222@kadam>
References: <20210213001412.4154051-10-olteanv@gmail.com>
 <20210215130003.GL2087@kadam>
 <20210215131931.4nibzc53doqiignb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215131931.4nibzc53doqiignb@skbuf>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9895 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102150114
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9895 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102150115
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 03:19:31PM +0200, Vladimir Oltean wrote:
> Hi Dan,
> 
> On Mon, Feb 15, 2021 at 04:00:04PM +0300, Dan Carpenter wrote:
> > db->index is less than db->num_ports which 32 or less but sometimes it
> > comes from the device tree so who knows.
> 
> The destination port mask is copied into a 12-bit field of the packet,
> starting at bit offset 67 and ending at 56:
> 
> static inline void ocelot_ifh_set_dest(void *injection, u64 dest)
> {
> 	packing(injection, &dest, 67, 56, OCELOT_TAG_LEN, PACK, 0);
> }
> 
> So this DSA tagging protocol supports at most 12 bits, which is clearly
> less than 32. Attempting to send to a port number > 12 will cause the
> packing() call to truncate way before there will be 32-bit truncation
> due to type promotion of the BIT(port) argument towards u64.
> 
> > The ocelot_ifh_set_dest() function takes a u64 though and that
> > suggests that BIT() should be changed to BIT_ULL().
> 
> I understand that you want to silence the warning, which fundamentally
> comes from the packing() API which works with u64 values and nothing of
> a smaller size. So I can send a patch which replaces BIT(port) with
> BIT_ULL(port), even if in practice both are equally fine.

I don't have a strong feeling about this...  Generally silencing
warnings just to make a checker happy is the wrong idea.

To be honest, I normally ignore these warnings.  But I have been looking
at them recently to try figure out if we could make it so it would only
generate a warning where "db->index" was known as possibly being in the
32-63 range.  So I looked at this one.

And now I see some ways that Smatch could have parsed this better...

regards,
dan carpenter

