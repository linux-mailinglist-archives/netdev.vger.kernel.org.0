Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6975018C490
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 02:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgCTBRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 21:17:14 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:33503 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgCTBRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 21:17:14 -0400
Received: by mail-qt1-f174.google.com with SMTP id d22so3716201qtn.0;
        Thu, 19 Mar 2020 18:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QHavipgYSNzUAjtspromspMTgYTom3kwMhXscnzi4bA=;
        b=ANo2YGyYS/aMgcH29Bkyjf3L68lI+JdTb8uBYs0jbOjfmE3S8hnXh5i/Y4sgBAB5P3
         Oy1KFAvFKGYzIn2IJg5wdjRO4+mtrrXU2fVupVrmiNtT7S4+eulKFqtzvh6zzuh9YqH2
         iE8FfvkBb3nzvuqc7Oa/kE7xPA7yXrYjaQko1+s/M/fqS0qRDlely0IZofZM24KcEbFX
         9k7vzUYefx3iYeLbZk/by+BGwP4pkJ99jpZhb/2j0QADoYA+iHGiEJHV3dEJ0uCAtMvT
         pT6VsvEf4lETcxg7lxARtWPtFSwf3xoGjghzcH4j2L9uPu2HpRKqxYnhCaYxlXv2ePvz
         x55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QHavipgYSNzUAjtspromspMTgYTom3kwMhXscnzi4bA=;
        b=hV8Ic9S2hxwInVvq1CSCYy3q+czWVDe5xiuyqY1TWIBOi8rXYyM1zSIljEVodmQktj
         2hDY3u0m89rLgFtr5eJL+mfdL6m7OENr9wIl9UdZQ/8Ywsh0OBSIRYt1VnNDx7bLQKVf
         o0mY6+woIkH/icf32mb1zMTROPFHTx9bHqfbYABMuoUJHfZD+WKqYdie+xpBTdg1sBz5
         kGSjGtD7s9i8IMfVO+6Th8IPU7pvpXcs2tdTO5F9ID4saNZHEvjFQ1kkSSDDT0CU79+J
         HM1BspA/UwCLbrVSny5iEci0/7RABX/7MEpkIUylkZTByeKNkF48S0SdU4fkYjsB0rBV
         9dlg==
X-Gm-Message-State: ANhLgQ2kCsp3GT/j+8sSepaD5kH62l6E8GCyn/ZjyWwSnYrVk6S2ql04
        Kn6YymFP6RdTkUv42x9DrcM=
X-Google-Smtp-Source: ADFU+vsq7hdtsaCbYqG7tUSQQrmGx0RogeROUuLZuLG/Kn1wi7/kIEp0004iJVQSM97XczjrwGI8hw==
X-Received: by 2002:ac8:4549:: with SMTP id z9mr6071023qtn.274.1584667032585;
        Thu, 19 Mar 2020 18:17:12 -0700 (PDT)
Received: from localhost.localdomain ([177.220.176.176])
        by smtp.gmail.com with ESMTPSA id q24sm3156790qtk.45.2020.03.19.18.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 18:17:11 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 4F225C1B52; Thu, 19 Mar 2020 22:17:09 -0300 (-03)
Date:   Thu, 19 Mar 2020 22:17:09 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     syzbot <syzbot+3950016bd95c2ca0377b@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        b.zolnierkie@samsung.com, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, kuba@kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, lkundrak@v3.sk,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: general protection fault in sctp_ulpevent_nofity_peer_addr_change
Message-ID: <20200320011709.GE3756@localhost.localdomain>
References: <00000000000074219d05a139e082@google.com>
 <00000000000041ca9305a13ea3e0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000041ca9305a13ea3e0@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 05:48:02PM -0700, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit da2648390ce3d409218b6bbbf2386d8ddeec2265
> Author: Lubomir Rintel <lkundrak@v3.sk>
> Date:   Thu Dec 20 18:13:09 2018 +0000
> 
>     pxa168fb: trivial typo fix

Certainly not ;-)
