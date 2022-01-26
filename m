Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A479349D201
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 19:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244200AbiAZSrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 13:47:06 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:45384 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiAZSrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 13:47:04 -0500
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id EA0F0200BE53;
        Wed, 26 Jan 2022 19:46:59 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be EA0F0200BE53
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1643222820;
        bh=dNzpTf+g8AGDj9g5Ti6fDn2XFHz4qj1O9OEgW+rgG8U=;
        h=From:To:Cc:Subject:Date:From;
        b=MqH3oPMyYG0MynMxSwtJZ6TqVqv9Qgkm929fZgFWd5wMYE0/S3eeg/fUsdl/ClAi/
         Q3MT8fAIQ9S2TsnjgKdRoiopmE7fMxIxF37cwn3cbfSYrfbhE5XiYeeFD63SkIEw+5
         vaRrW76AExbR27VZk7KlLLLW8l6YwOKaODjPhAvKHyRp5nM3bqQ8nAGOSFmS4WuRne
         wDaU6new2ygzlZLdIeYQG9uo7+8rkwgXxXnSpaJ58s/ApoNQ0UIrf0yeTozcIwYSa6
         G8Q9v+7rpFjigRgXgO+nMrhp0fXggmNA8BVqOByKcakNgvIpVqlk/VZ7BJS+8HwLfp
         65hb0rdPBK+zQ==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net-next 0/2] Support for the IOAM insertion frequency
Date:   Wed, 26 Jan 2022 19:46:26 +0100
Message-Id: <20220126184628.26013-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The insertion frequency is represented as "k/n", meaning IOAM will be
added to {k} packets over {n} packets, with 0 < k <= n and 1 <= {k,n} <=
1000000. Therefore, it provides the following percentages of insertion
frequency: [0.0001% (min) ... 100% (max)].

Not only this solution allows an operator to apply dynamic frequencies
based on the current traffic load, but it also provides some
flexibility, i.e., by distinguishing similar cases (e.g., "1/2" and
"2/4").

"1/2" = Y N Y N Y N Y N ...
"2/4" = Y Y N N Y Y N N ...

Justin Iurman (2):
  uapi: ioam: Insertion frequency
  ipv6: ioam: Insertion frequency in lwtunnel output

 include/uapi/linux/ioam6_iptunnel.h |  9 +++++
 net/ipv6/ioam6_iptunnel.c           | 57 ++++++++++++++++++++++++++++-
 2 files changed, 64 insertions(+), 2 deletions(-)

-- 
2.25.1

