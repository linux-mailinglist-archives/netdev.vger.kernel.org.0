Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20F033ADB7
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 09:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhCOIiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 04:38:21 -0400
Received: from smtpout2.vodafonemail.de ([145.253.239.133]:38572 "EHLO
        smtpout2.vodafonemail.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhCOIiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 04:38:03 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2021 04:38:01 EDT
Received: from smtp.vodafone.de (smtpa05.fra-mediabeam.com [10.2.0.36])
        by smtpout2.vodafonemail.de (Postfix) with ESMTP id AA398120E64
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 09:30:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arcor.de;
        s=vfde-smtpout-mb-15sep; t=1615797013;
        bh=XfNmTdWcSPGh/iEmCVpyIYCqLqCbkMtnRLOm11mLxI0=;
        h=Subject:From:To:Date;
        b=RFElKrtKOgq1M2AIcrVmNfvSA35zrbszxNgWAomXYwwyWnL1z+X9WJXvxhta1jFdd
         PBGsP8JRO+IkUvVonaBZ2wmUdoDIvbpohzf3nL4UchDEGEEnVio7kFITVDwizDPYzr
         PN+eoMhxCEZUW7/sKyB5Zwa+dGPVgsbdD5pLyabo=
Received: from MS7501.fritz.box (unknown [87.123.164.116])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id 4C03F1413FC
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:30:13 +0000 (UTC)
Message-ID: <fe0c34409428f100fb2e602e021062b8c4df4b6b.camel@arcor.de>
Subject: [PATCH] Fix error message generated in routel script when have
 'multicase' in routing list
From:   "B.Arenfeld" <b.arenfeld@arcor.de>
To:     netdev@vger.kernel.org
Date:   Mon, 15 Mar 2021 09:30:07 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-purgate-size: 888
X-purgate-ID: 155817::1615797013-00000891-3F82F881/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello :-)

I'm on an machine with Manjaro Linux. 
I get some error messages from shift command in the routel script:
/usr/bin/routel: Zeile 48: shift: shift count out of range

Reason are lines from "ip route list table 0" starting with word "multicast" :
 
multicast ff00::/8 dev enp2s0 table local proto kernel metric 256 pref medium

I added the "multicast" word in routel script and everything is fine ;-)

Greetings

Burkhard Arenfeld


Signed-off-by: Burkhard Arenfeld <b.arenfeld@arcor.de>

--- routel.orig	2021-03-15 08:23:24.706677247 +0100
+++ routel	2021-03-15 08:23:20.293589911 +0100
@@ -25,7 +25,7 @@ ip route list table "$@" |
     src=""
     table=""
     case $network in
-       broadcast|local|unreachable) via=$network
+       broadcast|local|multicast|unreachable) via=$network
           network=$1
           shift
           ;;


