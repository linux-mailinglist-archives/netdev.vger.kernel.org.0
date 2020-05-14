Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18291D365F
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 18:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgENQW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 12:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgENQW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 12:22:26 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A29CC061A0C;
        Thu, 14 May 2020 09:22:26 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id j3so3863746ilk.11;
        Thu, 14 May 2020 09:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=nzD/yKp7s5rBlG1Z64rwV9wa35iUFygskLzBnMHbd9A=;
        b=UbtFhxevqZg2/SEjHda1rCBcRaTs2r2mtesVa5G040pqLeo+MPe9z3qhMG5DSp1sVx
         wB2aDoZytCAzLibMEbV6yQjUpcBhI6qYCAdgBBdYCb4YE3gnrxVMfM6y7d8IqGNe7AbJ
         CIXvq/VDAWX8cRK6KAePCZzF3vVEc7GyxyiNi8rEBKuWYosLEjj6dymhl7DQ9Hb6AnuK
         yK1GmBwvNKRHVWM0fBTNKqvgqEI2yuQV4dBvm7RuJ0hviIEz3gj/UlQ2ABdEvgz/cbPq
         6e8YDGsA6JPExIVpvq2JA9b+0uAgtlqceqIHO4xPsDr6iXgXLbvGgM1NNCvpjsbLtZvA
         N8fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=nzD/yKp7s5rBlG1Z64rwV9wa35iUFygskLzBnMHbd9A=;
        b=b6ngBtyM5WnwqohsRJ0yPzZhrzEi43wXue7pAtuzrEol2iTdqnqP8KUdPrBahzKi+P
         OKNJgVRLlfq4ezqAveM70o/Io3wN3E5d+q8tVG3y22uMfUHX6MYCrj/M8H831SrZKJYo
         W85lRXCCIWDh54/06JWwjHELyQK67h80T6HAtbKd1j9lr/kE3HkAnDKzkm/dqh4UmP3g
         GKZyYu50kh+XUuu445mwX9eWH47n2B6uBOIqRblp5DmRMMwHBLuO8XBrjseq//YGHaCB
         OCygosM9rwsCfTYnI7vKUMFBHuUrv0mgI9Wb/Iyz8SW0vzxR3tXzCp9sJqm/w1cdWWIe
         y3sA==
X-Gm-Message-State: AOAM532XEt0Khe0FK6LLiImt2naxA1gp35kp+ir19hJ5N36Y9EwF/KUU
        QAAk7iPu0OOc5+WIHIqgNqM=
X-Google-Smtp-Source: ABdhPJwSBYQqAFj7KSXdcIbjRv8+2jUv1jMi4cBMY8SL5fZzaKp5ZAKKdRL1lPtJ/LJYqgjQdTJuzA==
X-Received: by 2002:a92:8752:: with SMTP id d18mr5666018ilm.224.1589473345919;
        Thu, 14 May 2020 09:22:25 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q78sm1317479ilb.25.2020.05.14.09.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 09:22:25 -0700 (PDT)
Date:   Thu, 14 May 2020 09:22:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, mhiramat@kernel.org,
        brendan.d.gregg@gmail.com, hch@lst.de, john.fastabend@gmail.com,
        yhs@fb.com, Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5ebd70394430_7d272b1d03c705c47c@john-XPS-13-9370.notmuch>
In-Reply-To: <20200514161607.9212-3-daniel@iogearbox.net>
References: <20200514161607.9212-1-daniel@iogearbox.net>
 <20200514161607.9212-3-daniel@iogearbox.net>
Subject: RE: [PATCH bpf 2/3] bpf: add bpf_probe_read_{user, kernel}_str() to
 do_refine_retval_range
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> Given bpf_probe_read{,str}() BPF helpers are now only available under
> CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE, we need to add the drop-in
> replacements of bpf_probe_read_{kernel,user}_str() to do_refine_retval_range()
> as well to avoid hitting the same issue as in 849fa50662fbc ("bpf/verifier:
> refine retval R0 state for bpf_get_stack helper").
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Yonghong Song <yhs@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
