Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BC52DB48D
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 20:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgLOThh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 14:37:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54156 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbgLOThX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 14:37:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFJXwiL157506;
        Tue, 15 Dec 2020 19:36:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=YobLz1Ds6I8pWJCq3iLIbappGSFWxMPj1YhXwhj5bK4=;
 b=HvhaK+z28o/dtjhUO9+IRDBxSG/1x/A0TYzok3gy2bTcEG9rRa8IAD/qVmJiykGXkvGH
 x51xkKBoF8yYFdZ4ls9A27+//Mb1gdf9aBZpkp7PLjPYjdhZaTwlf1xmWn2MBQ3e4Tb+
 KlNqw3adH8HMI3+ESkqx/uOtAoIR0NLBFVGJscTYt8F2ueGGebGSDmHkBxCzNrnBX67H
 6stEBUKWqUcSEll7il/g1I7cclihxDhgWtrQHri02l8gleZ9aB0nRc1Y926mZU6NnE0N
 pt6lrb4LOdhL8J4h+xJMUkMLGXW8slHm7vq/VfDwB2lTig1HuYED/ewC5pG7nXRHWZxc 7A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35cntm4dwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Dec 2020 19:36:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFJZ83J009610;
        Tue, 15 Dec 2020 19:36:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35e6jrmas5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 19:36:01 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BFJZvrs016736;
        Tue, 15 Dec 2020 19:35:57 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Dec 2020 11:35:56 -0800
Date:   Tue, 15 Dec 2020 22:35:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        davem@davemloft.net, kuba@kernel.org, wens@csie.org,
        jernej.skrabec@siol.net, timur@kernel.org,
        song.bao.hua@hisilicon.com, f.fainelli@gmail.com, leon@kernel.org,
        hkallweit1@gmail.com, wangyunjian@huawei.com, sr@denx.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: allwinner: Fix some resources leak in the error
 handling path of the probe and in the remove function
Message-ID: <20201215193545.GJ2809@kadam>
References: <20201214202117.146293-1-christophe.jaillet@wanadoo.fr>
 <20201215085655.ddacjfvogc3e33vz@gilmour>
 <20201215091153.GH2809@kadam>
 <20201215113710.wh4ezrvmqbpxd5yi@gilmour>
 <54194e3e-5eb1-d10c-4294-bac8f3933f47@wanadoo.fr>
 <20201215190815.6efzcqko55womf6b@gilmour>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201215190815.6efzcqko55womf6b@gilmour>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150130
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 08:08:15PM +0100, Maxime Ripard wrote:
> On Tue, Dec 15, 2020 at 07:18:48PM +0100, Christophe JAILLET wrote:
> > Le 15/12/2020 à 12:37, Maxime Ripard a écrit :
> > > On Tue, Dec 15, 2020 at 12:11:53PM +0300, Dan Carpenter wrote:
> > > > On Tue, Dec 15, 2020 at 09:56:55AM +0100, Maxime Ripard wrote:
> > > > > Hi,
> > > > > 
> > > > > On Mon, Dec 14, 2020 at 09:21:17PM +0100, Christophe JAILLET wrote:
> > > > > > 'irq_of_parse_and_map()' should be balanced by a corresponding
> > > > > > 'irq_dispose_mapping()' call. Otherwise, there is some resources leaks.
> > > > > 
> > > > > Do you have a source to back that? It's not clear at all from the
> > > > > documentation for those functions, and couldn't find any user calling it
> > > > > from the ten-or-so random picks I took.
> > > > 
> > > > It looks like irq_create_of_mapping() needs to be freed with
> > > > irq_dispose_mapping() so this is correct.
> > > 
> > > The doc should be updated first to make that clear then, otherwise we're
> > > going to fix one user while multiples will have poped up
> > > 
> > > Maxime
> > > 
> > 
> > Hi,
> > 
> > as Dan explained, I think that 'irq_dispose_mapping()' is needed because of
> > the 'irq_create_of_mapping()" within 'irq_of_parse_and_map()'.
> > 
> > As you suggest, I'll propose a doc update to make it clear and more future
> > proof.
> 
> Thanks :)
> 
> And if you feel like it, a coccinelle script would be awesome too so
> that other users get fixed over time
> 
> Maxime

Smatch has a new check for resource leaks which hopefully people will
find useful.

https://github.com/error27/smatch/blob/master/check_unwind.c

To check for these I would need to add the following lines to the table:

        { "irq_of_parse_and_map", ALLOC, -1, "$", &int_one, &int_max},
        { "irq_create_of_mapping", ALLOC, -1, "$", &int_one, &int_max},
        { "irq_dispose_mapping", RELEASE, 0, "$"},

The '-1, "$"' means the returned value.  irq_of_parse_and_map() and
irq_create_of_mapping() return positive int on success.

The irq_dispose_mapping() frees its zeroth parameter so it's listed as
'0, "$"'.  We don't care about the returns from irq_dispose_mapping().

It doesn't apply in this case but if a function frees a struct member
then that's listed as '0, "$->member_name"'.

regards,
dan carpenter

