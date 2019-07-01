Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E201A5C578
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 00:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfGAWEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 18:04:49 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44547 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfGAWEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 18:04:49 -0400
Received: by mail-qt1-f196.google.com with SMTP id x47so16347090qtk.11
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 15:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=tdUJDpmJyvTyeb2mvnZzsOk0Mh/UFIrC52wTJgenPBA=;
        b=ngPjHjPjpNCHd7ucjfiB48oO80YydCY0C0m5i4eBV8XYrvqS8wjAdUwpqfaGYSNUiD
         u0BaC1zom9Fyy33qYW36qKcM6jBQuZpnZlmdBci7aJQI/YEMufwdWn9lBMLLRX5jhz79
         a/lyndwNF4HUNurrmrWDf23Yz+YkimBB2UATbrJ9us8nXlaUUT5PKAhzELHYZmLfLD+w
         3T3NiblDqq7KoPiM0qBimCXnyE+vhHd0RVjN9FWTD5tbZDAn+cKsB7VsShhIP8uJSzkZ
         87N2A++hNwF6ARLVYO2BZEREcZNTfTEwrxCekaHPX3UO71dP8+Zz5RX43ubaU8xIaX5t
         2lvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=tdUJDpmJyvTyeb2mvnZzsOk0Mh/UFIrC52wTJgenPBA=;
        b=cNwA4eMpiht3l+rzig219Dtjnyc+R+esJju42L5JgWuOeCZLsaAAl4eoBI3VDPJTf1
         4ZY1vzrLe8U5wt/gcRYTE8urBPNMOiZZ2dmXJmKiweQxtu12VDSJojKnz2gDcWSGJvU6
         UR0Apoct/wUKd5MM/MjObLznhm776EHOfbzBryqW41ur5lg5/1e6a31vmg3PEIAc2SFx
         i2zARRLrrR3tQo5jyEN2xD3yHnilSpPtRL6p2JgxPKwwrSaCNbILcKM73rTDTkRYM/mr
         3fGURha/vZEhyBOeNSHuVpZxfNQ9KZeO6WgDsmSjpBBRuqEDCnaSU7VHXqf0xOoFvUEq
         Fthg==
X-Gm-Message-State: APjAAAX64RanuQydomuxhwtOba18A0b4zICUdkvPCsYAG7iQe+X2z5ZH
        r6uwROJvsTjXEKRc3lz508u9NA==
X-Google-Smtp-Source: APXvYqx3+GhEhtESPFn48ANSzScSbB75065DoJ4pPYAmOGTNF/GY53Z5/Kv/tSHv7WO3EZt1FJeR2Q==
X-Received: by 2002:a0c:9274:: with SMTP id 49mr23532847qvz.119.1562018688252;
        Mon, 01 Jul 2019 15:04:48 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g53sm6488457qtk.65.2019.07.01.15.04.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 15:04:48 -0700 (PDT)
Date:   Mon, 1 Jul 2019 15:04:43 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 4/4] tools/bpftool: switch map event_pipe to
 libbpf's perf_buffer
Message-ID: <20190701150443.1e43e818@cakuba.netronome.com>
In-Reply-To: <20190630065109.1794420-5-andriin@fb.com>
References: <20190630065109.1794420-1-andriin@fb.com>
        <20190630065109.1794420-5-andriin@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Jun 2019 23:51:09 -0700, Andrii Nakryiko wrote:
> Switch event_pipe implementation to rely on new libbpf perf buffer API
> (it's raw low-level variant).
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

> -int do_event_pipe(int argc, char **argv)
> -{
> -	int i, nfds, map_fd, index = -1, cpu = -1;
>  	struct bpf_map_info map_info = {};
> -	struct event_ring_info *rings;
> -	size_t tmp_buf_sz = 0;
> -	void *tmp_buf = NULL;
> -	struct pollfd *pfds;
> +	struct perf_buffer_raw_opts opts;

I'm slightly worried we don't init the ops, but we can wait and see if
it bites us or not.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thanks!
