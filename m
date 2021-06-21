Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311493AEACB
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 16:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhFUONC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 10:13:02 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59756 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229736AbhFUONA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 10:13:00 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LE8HDr026284;
        Mon, 21 Jun 2021 14:10:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=K9k3g/KXhuuJFyN8zef+KDQYsO6LeNTUi5TxPfegZz4=;
 b=hvnFga7sjr1SDtgv/rXrNHncgYXeHFHsTXi6Zhg+sd+9jYvaVxVmLbxdOsIzft6ghpLg
 8HjtOeYX1GfDXrQYEYR8hTUCJXumyDAeBCRsMG84fATQ4/XqTUHBWAVKTjXscjIcxCjp
 OrGkv7HgZN3c38QOtjVYefW2ur/idwMLoSTJ+T6+s6GJY3VSlrAy5Tft8OQbwQxZNh/9
 WUIcEG/3TnZEZ7gul+Ct0jMXMv6AYP5bbGyWg48IsJU11pL6kJu6r4ReG5PGqcc8NmrV
 1mJg09BT6W5vLX0wvcocXv978Yf5UVFywfBIQALzjcWzW+kw3usDToPT7c69IN3P2soH AQ== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39a68y1rgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 14:10:38 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15LE9j9r149881;
        Mon, 21 Jun 2021 14:10:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3998d5wmhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 14:10:37 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15LEA4Kc151016;
        Mon, 21 Jun 2021 14:10:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3998d5wmgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 14:10:37 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.14.4) with ESMTP id 15LEAZYk026765;
        Mon, 21 Jun 2021 14:10:35 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Jun 2021 07:10:34 -0700
Date:   Mon, 21 Jun 2021 17:10:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 01/19] staging: qlge: fix incorrect truesize accounting
Message-ID: <20210621141027.GJ1861@kadam>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-2-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621134902.83587-2-coiby.xu@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: B_qUZsMMkgZVgh812UNKgPfPTPQunNUL
X-Proofpoint-GUID: B_qUZsMMkgZVgh812UNKgPfPTPQunNUL
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 09:48:44PM +0800, Coiby Xu wrote:
> Commit 7c734359d3504c869132166d159c7f0649f0ab34 ("qlge: Size RX buffers
> based on MTU") introduced page_chunk structure. We should add
> qdev->lbq_buf_size to skb->truesize after __skb_fill_page_desc.
> 

Add a Fixes tag.

The runtime impact of this is just that ethtool will report things
incorrectly, right?  It's not 100% from the commit message.  Could you
please edit the commit message so that an ignoramous like myself can
understand it?

Why is this an RFC instead of just a normal patch which we can apply?

regards,
dan carpenter

