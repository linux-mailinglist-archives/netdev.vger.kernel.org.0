Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD347491E87
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 05:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbiAREc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 23:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiAREc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 23:32:57 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EF3C061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 20:32:56 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id p37so12001381pfh.4
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 20:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O0lpaYF7s0wGX1zon0EqNDWXNWFKqt28loYQ2pWheug=;
        b=EB7C8ZkQmDtlNlKeeH0fzCH3KfiV+CB6EHZTXirXt6MKkqbfLAVrva8fsHHwiL94Fd
         PYkAowLTYuvexocGRDZfv2amh6DJ0N/xt3somry5URBI6s3CGUMEwsiFig3pmoJdQeT9
         c95pnF0lq1fEjdvnEclO5E5klSiaTxTzL0fLNGit6ut1+val9Vg2LSktdGMxQ8TxazL/
         QfamctgpZkX3Klp5mMxg2QX+X1AgpINqw+BiTUwfnmjk2CljtTZ9X/bpm4qhBnmE7HQ6
         rWJAyEU9PFmh8JSIEpYKeYyOBAZjI+/+H4NIGC2Zf0V0HMeaVqigL8a3zxyEDBraG/FQ
         unbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O0lpaYF7s0wGX1zon0EqNDWXNWFKqt28loYQ2pWheug=;
        b=hM+/WyY0snpVCLnYUL8c8CpjuBsl0ncJsPjxdLo5HUdPx8CJA5yjGv9eRH77q4Mrzo
         j7ztUIKwu9eFbBHicHxQa/dmXuR7teqhkjLcRQG6hl7YfYe1w7NSO2nIEHafu5uoQqqQ
         zROloXMfsJCeiW6+lJ6NmB/A96hDYWdZbVL8l+aeMLuPaIDg5fDOlT6hYWY5RJBe0rye
         9FAmx6MgepK+Fx9wPQQNTjcVbmKUAVxk4ueAoUaAlvZzOgzzXwy4sd+e0hI6A4Difg2S
         LjE9RNVmXASE7jcCfwRwZ3un7ctMqNlllIhMUjuhnhnvCdu9BTg3G1MNLKvFf+J3b2uW
         FnUA==
X-Gm-Message-State: AOAM531hBqeZrpClUNhCd0Hm19jVjXh4Y/m7CzodohNH/EOgSgw/z/EE
        jJfo45ZMQ9EnoOtUV9r4ib7Bow==
X-Google-Smtp-Source: ABdhPJzOzt3pP0sCyWPuVW6QZ9FHoEMp5vN3G5DN1jlwmf77WwNoQBYGnvxN2pZbkB1KhcMPIh97RA==
X-Received: by 2002:a05:6a00:138e:b0:4c0:e0cd:bf97 with SMTP id t14-20020a056a00138e00b004c0e0cdbf97mr24561225pfg.12.1642480376469;
        Mon, 17 Jan 2022 20:32:56 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id c19sm15473987pfo.91.2022.01.17.20.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 20:32:56 -0800 (PST)
Date:   Mon, 17 Jan 2022 20:32:54 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wen Liang <liangwen12year@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: Re: [PATCH iproute2 v4 2/2] tc: u32: add json support in
 `print_raw`, `print_ipv4`, `print_ipv6`
Message-ID: <20220117203254.2ef76af1@hermes.local>
In-Reply-To: <562f7200730502e65486cac9341cdbedac84c5be.1642472827.git.wenliang@redhat.com>
References: <cover.1642472827.git.wenliang@redhat.com>
        <562f7200730502e65486cac9341cdbedac84c5be.1642472827.git.wenliang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jan 2022 21:42:21 -0500
Wen Liang <liangwen12year@gmail.com> wrote:

> Signed-off-by: Wen Liang <liangwen12year@gmail.com>

More checkpatch warnings, please fix.

WARNING: Missing commit description - Add an appropriate one

WARNING: suspect code indent for conditional statements (24, 33)
#100: FILE: tc/f_u32.c:855:
 			if (bits >= 0) {
+				 const char *addr;

WARNING: Statements should start on a tabstop
#106: FILE: tc/f_u32.c:856:
+				 const char *addr;

WARNING: Statements should start on a tabstop
#107: FILE: tc/f_u32.c:857:
+				 if (key->off == 12) {

WARNING: Missing a blank line after declarations
#107: FILE: tc/f_u32.c:857:
+				 const char *addr;
+				 if (key->off == 12) {

WARNING: suspect code indent for conditional statements (33, 39)
#107: FILE: tc/f_u32.c:857:
+				 if (key->off == 12) {
+				       print_nl();

WARNING: Statements should start on a tabstop
#111: FILE: tc/f_u32.c:861:
+				 } else {

WARNING: suspect code indent for conditional statements (33, 39)
#111: FILE: tc/f_u32.c:861:
+				 } else {
+				       print_nl();

WARNING: Statements should start on a tabstop
#115: FILE: tc/f_u32.c:865:
+				 }

WARNING: Missing a blank line after declarations
#200: FILE: tc/f_u32.c:933:
+				const char *addr;
+				if (key->off == 12) {

WARNING: suspect code indent for conditional statements (32, 38)
#200: FILE: tc/f_u32.c:933:
+				if (key->off == 12) {
+			              print_nl();

ERROR: code indent should use tabs where possible
#201: FILE: tc/f_u32.c:934:
+^I^I^I              print_nl();$

WARNING: suspect code indent for conditional statements (32, 38)
#204: FILE: tc/f_u32.c:937:
+				} else {
+			              print_nl();

ERROR: code indent should use tabs where possible
#205: FILE: tc/f_u32.c:938:
+^I^I^I              print_nl();$

total: 2 errors, 12 warnings, 198 lines checked
