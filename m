Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F020B3FD5
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 19:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388708AbfIPR55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 13:57:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57704 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbfIPR55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 13:57:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GHrxIj060857;
        Mon, 16 Sep 2019 17:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MW04ABQyhX38L88BI5M8vCF1lPosi66PbWP7/kQtqpg=;
 b=PIAFpvxun7+qVBxZFDszVXHRA/MgZBM41g0e/eEHBbJuO7irIQIRez5bGELE/aB67CCd
 iOOeSdcQ2NhAz+aZn67SIS6GAvIZtGltv9wcA1cKaOX2ivnNctcfSkIU3Rz7cmsYsfgX
 b81W+KPanYtBGdhS0rh3LjS/Sv3zmV+AMd32kEUiKb44PKXT01kMKeG2ITCLUWLgKIGg
 09U64N9ao0ddUAP3RBuk4ACFY//NABdbYsJeezL3hmIWqMrd7PZ/0Y2Fit0AEG7WsHOj
 ChAPbrCoZwhw1OSwd2KhPn//1IjvevGXOLw68ez0NDOKGjitjs6KbO/DlLHNeEQ9QFYy Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2v2bx2sbv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 17:57:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GHrdYg179499;
        Mon, 16 Sep 2019 17:57:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2v0p8uxxp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Sep 2019 17:57:34 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8GHsJk8182132;
        Mon, 16 Sep 2019 17:57:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2v0p8uxxnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 17:57:33 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8GHvVD3028421;
        Mon, 16 Sep 2019 17:57:31 GMT
Received: from [10.209.226.111] (/10.209.226.111)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 10:57:31 -0700
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in rds_bind
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com>
Cc:     Arvid Brodin <arvid.brodin@alten.se>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        rds-devel@oss.oracle.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <000000000000bd36db0592ab9652@google.com>
 <CAM_iQpXdTNVywYm6+vmAKMsBRcC6ySOX9Rcg70xhgdjJgbDJkw@mail.gmail.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <d64dee71-4927-4589-d865-7abf4cc266e6@oracle.com>
Date:   Mon, 16 Sep 2019 10:57:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXdTNVywYm6+vmAKMsBRcC6ySOX9Rcg70xhgdjJgbDJkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/19 9:49 AM, Cong Wang wrote:
> On Mon, Sep 16, 2019 at 6:29 AM syzbot
> <syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    f4b752a6 mlx4: fix spelling mistake "veify" -> "verify"
>> git tree:       net
>> console output: https://syzkaller.appspot.com/x/log.txt?x=16cbebe6600000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=b89bb446a3faaba4
>> dashboard link: https://syzkaller.appspot.com/bug?extid=fae39afd2101a17ec624
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10753bc1600000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111dfc11600000
>>
>> The bug was bisected to:
>>
>> commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
>> Author: Cong Wang <xiyou.wangcong@gmail.com>
>> Date:   Thu Jul 4 00:21:13 2019 +0000
>>
>>       hsr: implement dellink to clean up resources
> 
> 
> The crash has nothing to do with this commit. It is probably caused
> by the lack of ->laddr_check in rds_loop_transport.
> 
Will have a look.

regards,
Santosh
