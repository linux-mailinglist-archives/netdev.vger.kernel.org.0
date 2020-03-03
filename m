Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE41177213
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 10:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgCCJLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 04:11:15 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40363 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbgCCJLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 04:11:14 -0500
Received: by mail-qk1-f194.google.com with SMTP id m2so2643559qka.7
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 01:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=zp5B66hwroB+O+qsn4WAg4Zqd4xo1ZX2ZLvZWkCZxhw=;
        b=gy8Ky95QIh+BdOhQpqJFEDGhbpmnqndckIk9cWMHE3TB/InvTJkXFLdBaGtKi5CAHN
         6qvIEstNkTrdWV9sBCbiYAAyM5eFGTSD1WfibfVJ/4Z8P9OeplWafkK8P4wBKpSCG4G5
         8Upyi9bpZD5k7DqaWbHJ693R0FxHVVCsYabSQ6Q8AqFt2nsxJIamKmBfXub615aWdwvj
         MlU2b50EZkRM94QW6bmWygRyhYlk/ai9KNy9OU5SJmId33FdCqoxphVpMhNdkDBBi6Rr
         VV0rzbAVUP7OmjHu9ZySqRKJHzhbEIfgiWKquYRP6mr7TfU5MfO7Wi2bBrMinlAGo+QL
         6p9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=zp5B66hwroB+O+qsn4WAg4Zqd4xo1ZX2ZLvZWkCZxhw=;
        b=ouTLl1s8QQKHaF44cjm2vwMSY70o6i9LBirUXYiX65fWVByAOfiYWWPb6yFe6PlPXY
         6wavKLMlaoi8fCZvA13ZBxrE16Ikouswdd3NVhP95EXOBmwSA3M1h/eN4c9mQOuL/s/w
         x33jnTcZXBqIPxW1kZtpmElhHBxZwdYDPJYPDdr/cqoJIPfLS1yqkgAMheTTJ9gcXqt3
         L1WMU95jqBRrEXI0+fRcyjRP1yzEvxNBjZorjuKSfD+7SW+t5LBhzB5VPQrJ5lV3npJk
         HPZgok+PMGgSbZFmiyP2ysPpcg+c/gxVTpSti1aM8C+Cei30uMUdYcfyTy/vPGBprV06
         594g==
X-Gm-Message-State: ANhLgQ2nspeUxaj2pJTNMXYzMJxvpl42cY2ipGVXBpmHYcyZ1FoXAgR1
        M4p2jpTJfCUndci3X0jg9dE=
X-Google-Smtp-Source: ADFU+vuJ1PgnrjYpb/nWPTgFTzhgqBvbCQod2HJK79h9xGHOOFlp3j/H+n+d4erxZMLAs2f32IHR7g==
X-Received: by 2002:ae9:c10c:: with SMTP id z12mr3055055qki.56.1583226672907;
        Tue, 03 Mar 2020 01:11:12 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q3sm614841qtf.67.2020.03.03.01.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 01:11:12 -0800 (PST)
Date:   Tue, 3 Mar 2020 17:11:05 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
Message-ID: <20200303091105.GW2159@dhcp-12-139.nay.redhat.com>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
 <20200303090035.GV2159@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200303090035.GV2159@dhcp-12-139.nay.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 05:00:35PM +0800, Hangbin Liu wrote:
> On Tue, Mar 03, 2020 at 07:16:44AM +0100, Rafał Miłecki wrote:
> > It appears that every interface up & down sequence results in adding a
> > new ff02::2 entry to the idev->mc_tomb. Doing that over and over will
> > obviously result in running out of memory at some point. That list isn't
> > cleared until removing an interface.
> 
> Thanks Rafał, this info is very useful. When we set interface up, we will
> call ipv6_add_dev() and add in6addr_linklocal_allrouters to the mcast list.
> But we only remove it in ipv6_mc_destroy_dev(). This make the link down save
> the list and link up add a new one.
> 
> Maybe we should remove the list in ipv6_mc_down(). like:

Or maybe we just remove the list in addrconf_ifdown(), as opposite of
ipv6_add_dev(), which looks more clear.

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 164c71c54b5c..4369087b8b74 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3841,6 +3841,12 @@ static int addrconf_ifdown(struct net_device *dev, int how)
                ipv6_ac_destroy_dev(idev);
                ipv6_mc_destroy_dev(idev);
        } else {
+               ipv6_dev_mc_dec(dev, &in6addr_interfacelocal_allnodes);
+               ipv6_dev_mc_dec(dev, &in6addr_linklocal_allnodes);
+
+               if (idev->cnf.forwarding && (dev->flags & IFF_MULTICAST))
+                       ipv6_dev_mc_dec(dev, &in6addr_linklocal_allrouters);
+
                ipv6_mc_down(idev);
        }

Thanks
Hangbin
