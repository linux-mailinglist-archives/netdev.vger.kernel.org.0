Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A37669D2A
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732070AbfGOUve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:51:34 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36614 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729640AbfGOUve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 16:51:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so8288556pgm.3
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 13:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yFb4nLlkGXtyewjPL6aHDFHiNnwUWqzNbmalePN7zSs=;
        b=bXXjZeqDTzlEbkLdWHvrCucSz6dwS7DDtFdjVIx05NwS5uYI5m6Pd2zS2Y5ORWUaIB
         ljMCZshij/yYxXdvkhAJR2u/fDPRFGU4IIU4eW4DNveiBLQtZyxS6tu7Jox65ezIH8j4
         GXJlso4GtQQOzi5LAYCPVFoFseBrqd42qGIolenc1P2XqnwmmbFohsFlBCl5nmc29b97
         b4C3D93HC/J/28LkLldpgE6rb7SyjocGAGLHPUC28UEaAQHmIHpzdDWe5MbUnXU4IoH8
         Jm7h62fbg9UKpv2+5ScWoadg4yQ22TzCvoQLZp4PcG8GMpZCch/56wx7VY91Fb2ppb+l
         V+0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yFb4nLlkGXtyewjPL6aHDFHiNnwUWqzNbmalePN7zSs=;
        b=Zq1q7DsXeG+sojDtACfYZb2rlSx2PGh16mCmpFUCAvHY0CXESWumctOToldeUriRJJ
         KyEtn09xcVqjfUXlnt551OK1IvezyMtFU474gFYUtJ40Hnzqri2k+TONCW4Me4/nTpKN
         j/owi9vpTlaZlufFbGpWIZsuIZNhPntpofEF0heuPKZQiCsSjgREqPyPx9Rb40bD/O4s
         bBxjUusgbfrLAsEwUfv5iXTx+S8mreunn6slCi6XruGTbwOsPg1mTEAvidaD9xja8Cmr
         9gkN0LD+Q7oKouwG/IpnK/bbzXshcW1KpxHGOdd8fx68dnrrc386AbH0IDjhcWbkrE+T
         PBcQ==
X-Gm-Message-State: APjAAAURU7KUnkC8pFtYRiYxNmQIGrUgtgSCIgwmrPGz+SH0IMCjCkLS
        UCybxsMim3aztWnW3Ww7nxI=
X-Google-Smtp-Source: APXvYqxSbIiSOpm3QbhX0ZUkZbD4ePgrdLwtyhTZfe470aVDFbGThDaGRuMAkpDYPKN/8i9tx6k+5A==
X-Received: by 2002:a17:90a:8591:: with SMTP id m17mr31974539pjn.100.1563223893530;
        Mon, 15 Jul 2019 13:51:33 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n17sm20231935pfq.182.2019.07.15.13.51.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:51:33 -0700 (PDT)
Date:   Mon, 15 Jul 2019 13:51:31 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     netdev@vger.kernel.org, moshe@mellanox.com, ayal@mellanox.com
Subject: Re: [PATCH iproute2 master 0/3] devlink dumpit fixes
Message-ID: <20190715135131.6e9f0ba0@hermes.lan>
In-Reply-To: <1562756601-19171-1-git-send-email-tariqt@mellanox.com>
References: <1562756601-19171-1-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Jul 2019 14:03:18 +0300
Tariq Toukan <tariqt@mellanox.com> wrote:

> Hi,
> 
> This series from Aya contains several fixes for devlink health
> dump show command with binary data.
> 
> In patch 1 we replace the usage of doit with a dumpit, which
> is non-blocking and allows transferring larger amount of data.
> 
> Patches 2 and 3 fix the output for binary data prints, for both
> json and non-json.
> 
> Series generated against master commit:
> 2eb23f3e7aaf devlink: Show devlink port number
> 
> Regards,
> Tariq
> 
> Aya Levin (3):
>   devlink: Change devlink health dump show command to dumpit
>   devlink: Fix binary values print
>   devlink: Remove enclosing array brackets binary print with json format
> 
>  devlink/devlink.c | 41 +++++++++++++++++++++--------------------
>  1 file changed, 21 insertions(+), 20 deletions(-)
> 

Applied
