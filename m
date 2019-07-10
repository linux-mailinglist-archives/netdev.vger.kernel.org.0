Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B91756466C
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 14:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfGJMlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 08:41:10 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44560 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfGJMlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 08:41:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so2280788wrf.11
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 05:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ROsNFih7aIvvYO4hZ5LpXiKTnrDc8efW5guC8WGQZAw=;
        b=hMiSgM6N75GSOTElnmJnUf6399W00z/c5NFuzls/PlisXc5PctICSFisgt6BTRVFki
         dDi2pavksb7Gi7U7CpyNKw4l7HO+dx/JWzJqWs3dTdmKJt1DqrTm21uvA2EtBcsHtz3m
         RWrvxL9Y0Oik2bfwbpWTX58RqdppWn+L4STnMCJkbHtFLppd7+FY9H8+c2J8lcAXA3g6
         TCVzgxUgJEjGIaxcP/ToBmdL8noIEfQcw6LdZcRnE2AJYj4gWzkjs3UIoyZFg9eok3YT
         4VSJerGT39rnyjqte02arLa8pZUUD6uoJWuYHLjrQMfJaAwRRT4s1CYCq4izJGcv3ZR+
         PXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ROsNFih7aIvvYO4hZ5LpXiKTnrDc8efW5guC8WGQZAw=;
        b=d9C2vaAmYlX2A8eEkDAfrKTeLmsNBg5ISWkVzIlrIff3KoRXvdN/AAz1J7RF8YjisU
         xV1en7cyYOXufNZ2MNkwU3A0fCaeN01ZsvNY1vqi0gxXd32SuvquEbhh+48GLnv/023d
         myjaC8FBmws58F3dMYhhXW54pLf5vMnZWNKk4Olmf109OjRwykgeQUUoLHjZksF322pX
         nMQ4iG1bc26AX/XkKzFIdAxqNrOicTbxMTFHbLFi24k6g7mO3e1spa0jITHlDWDHA+cp
         YZdzG0nRNv7qmIrtou8iSyMzhh1YryaQvyr5Kbt6QtVU3WsteX0iDvntOHiauuRGxG/6
         1LcQ==
X-Gm-Message-State: APjAAAWnJ6Hd9bBC+/+5tF9eAAh4Oc0ROeapla6Dd51n+gXi/U/mCiGV
        DuHj16GJLlNoi+whj+FhJDGxlzpoItc=
X-Google-Smtp-Source: APXvYqxeUHTLRpHHdHOouiMU7xUYWASATf6JPv2xluWAfvgOtNmlVgafFW0CJg6ieqYBvSBgGeiygA==
X-Received: by 2002:adf:e841:: with SMTP id d1mr31732704wrn.204.1562762466197;
        Wed, 10 Jul 2019 05:41:06 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id z5sm1406759wmf.48.2019.07.10.05.41.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 10 Jul 2019 05:41:05 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        stephen@networkplumber.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH iproute2-next v2 1/3] lib: add mpls_uc and mpls_mc as link layer protocol names
Date:   Wed, 10 Jul 2019 13:40:38 +0100
Message-Id: <1562762440-25656-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562762440-25656-1-git-send-email-john.hurley@netronome.com>
References: <1562762440-25656-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the llproto_names array to allow users to reference the mpls
protocol ids with the names 'mpls_uc' for unicast MPLS and 'mpls_mc' for
multicast.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 lib/ll_proto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/ll_proto.c b/lib/ll_proto.c
index 78c3961..2a0c1cb 100644
--- a/lib/ll_proto.c
+++ b/lib/ll_proto.c
@@ -78,6 +78,8 @@ __PF(TIPC,tipc)
 __PF(AOE,aoe)
 __PF(8021Q,802.1Q)
 __PF(8021AD,802.1ad)
+__PF(MPLS_UC,mpls_uc)
+__PF(MPLS_MC,mpls_mc)
 
 { 0x8100, "802.1Q" },
 { 0x88cc, "LLDP" },
-- 
2.7.4

