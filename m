Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE21118F9D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfLJSRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:17:20 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:38679 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbfLJSRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 13:17:20 -0500
Received: by mail-pj1-f68.google.com with SMTP id l4so7715453pjt.5
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 10:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NSUe4Dlnq/eVmmI9RrnQy5bu5fPS8XtosW1PP57fyEk=;
        b=cGAcejXCQHtpnBjye+7ngsK2pmYFOM9r0VCD7Y+1KASSHUeQDFocwSBRWtmGkbr1nm
         iRM5NK+/ctyKMnrmcqENEgSad0Tjs+0wJkwKK70ejjHEk7+bLAktEAtqsoql7qZcZpw3
         r4lnbhKXP3CC78W0sGeqN0EeixT7AFHGU2A4Teq7ByEApz3cjjfpT0G9Z52FDjHcr3jX
         2Sckts7bZrOv+GbcIkQW1qpAf6vwiheelER3yHLTI3N+6S4YSTOdUD7jsj5HMvnPN7Vx
         NK4XAfu+068U+dIVYep28iFy2U0kV936w8H3jVTXxkEax1LPfBfhb3GHr40Ahb1VTat/
         4wwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NSUe4Dlnq/eVmmI9RrnQy5bu5fPS8XtosW1PP57fyEk=;
        b=HqfSJAnQwhWMQRdtMVyhiaT+h4de12GJ7WsAi8xTSjQVGf9ctSr3vjJDMv5TeaW0xe
         LE0EOt7rxkHpbCb8hr5g3kALTYiHH8W8yt4nZYm40hsjQg3Lb1F0lt8V0QUq6iS/QTsg
         uTUxMxNT6sG42y5CWuZvUq5rk21BKFo1U5n9zcVLj6w0gzhMdIwNISYAI0c/CE0BnI0s
         OW/mRH8Kr3IxXdNDswc5ON03gene69+o653hcTWtXfAlCdyFkSlrDy/PpMR/CBdq08VS
         +9Nl0+riy8linUZINSmHW0cD5LgZoT43uqG5cFrRcgeoWDEqa1Y/xVO1lJlD3SH1QS8d
         pcFQ==
X-Gm-Message-State: APjAAAWRi/sD6DTPXHIjpT7/Uw/sC08M9Ctat3WBK/KgQqvl8qSOzVa2
        nQw5D9QNEmpAkpO8CPCFcrpdsg==
X-Google-Smtp-Source: APXvYqzgXxVQjEBKZ3Mi0lFQtZoHY01Pl/ne8zTb8kAqBDyYR+JfIlz4enqyg8dwMLtf6FX2NkCDdg==
X-Received: by 2002:a17:902:ab86:: with SMTP id f6mr33843103plr.78.1576001839701;
        Tue, 10 Dec 2019 10:17:19 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::3])
        by smtp.gmail.com with ESMTPSA id u18sm4082557pgi.44.2019.12.10.10.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 10:17:19 -0800 (PST)
Date:   Tue, 10 Dec 2019 10:17:16 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 03/15] libbpf: move non-public APIs from
 libbpf.h to libbpf_internal.h
Message-ID: <20191210101716.56c34afc@cakuba.netronome.com>
In-Reply-To: <CAEf4BzbYvNJ0VV2jHLVK3jwk+_GvVhSWk_-YM2Twu5XkZduZVQ@mail.gmail.com>
References: <20191210011438.4182911-1-andriin@fb.com>
        <20191210011438.4182911-4-andriin@fb.com>
        <20191209173353.64aeef0a@cakuba.netronome.com>
        <CAEf4BzbYvNJ0VV2jHLVK3jwk+_GvVhSWk_-YM2Twu5XkZduZVQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 09:04:58 -0800, Andrii Nakryiko wrote:
> > I thought this idea was unpopular when proposed?  
> 
> There was a recent discussion about the need for unstable APIs to be
> exposed to bpftool and we concluded that libbpf_internal.h is the most
> appropriate place to do this.

Mm. Do you happen to have lore link? Can't find now.

My recollection is that only you and Alexei thought it was
a good/workable idea.
