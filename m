Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BBB39F16C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhFHIzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:55:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:17778 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFHIzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:55:40 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1588lt9Q000998;
        Tue, 8 Jun 2021 08:53:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uXsfBS09h5r8atqX2PNh5Ig45l4lwTr4pwZjL/r3r08=;
 b=rIHqGiszTwgFXYU/29HrTXFSuOgR9+nwuryBFW68Xibj9DLPsIar+VXv/BI9MdswqoYW
 2qR4lyled93+VhADteVmUs9HeKBOAQyMh8qnNO8Fr5XK8r1U1S4AZ0uFyUc4sgJY9EIf
 +XrbhyeczsMbcIjlnA9yYyf/LrrpIKgiANecaz/VPhzenvG0jKqlG1h1YvJYHJEEt7RH
 mscM9rM8T6aLdp334Non989aCGXV6XRsWAl6PMNBuuz3mBtdfATRf1MNq5iz+iZ0jnLw
 MwQZc+pA5q0zFWnC/kVAdl3hiEU70Or7jAUNXolAmXEZy+puOr+cvoJseSgdfyJFalN6 Vw== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3916ehrkkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 08:53:27 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 1588pMAu194740;
        Tue, 8 Jun 2021 08:53:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 38yyaaqvpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 08:53:27 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1588rQWJ003308;
        Tue, 8 Jun 2021 08:53:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 38yyaaqvpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 08:53:26 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1588rJqi003329;
        Tue, 8 Jun 2021 08:53:22 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Jun 2021 08:53:18 +0000
Date:   Tue, 8 Jun 2021 11:53:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     SyzScope <syzscope@gmail.com>,
        syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        kernel-hardening@lists.openwall.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <20210608085310.GA1955@kadam>
References: <000000000000adea7f05abeb19cf@google.com>
 <2fb47714-551c-f44b-efe2-c6708749d03f@gmail.com>
 <YL3zGGMRwmD7fNK+@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL3zGGMRwmD7fNK+@zx2c4.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: 9xkxAKvdty5E81yk4zbMACfpHhdkZeVE
X-Proofpoint-ORIG-GUID: 9xkxAKvdty5E81yk4zbMACfpHhdkZeVE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This SyzScope stuff could be good in theory and it could be something
useful with more work.  But in real life terms do you know anyone who
looked at "use-after-free Read in hci_chan_del" and thought, "Oh that
sounds totally harmless."

regards,
dan carpenter

