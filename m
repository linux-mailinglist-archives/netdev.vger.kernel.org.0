Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF9E51FED
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbfFYAaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:30:10 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37639 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbfFYAaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 20:30:10 -0400
Received: by mail-qt1-f195.google.com with SMTP id y57so16583286qtk.4
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 17:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=x+tlmGCTQffoJAJ59dIRg7yQSWCd5WUCFuykrjOLls4=;
        b=LixfWFBfIpXX6WRX8fGmphWFTzmhKxse7rDVJyd9cH2FFJ35SPMgJc01BHOcH7M76/
         sxLA+wZeZLDp66UZX2jD++0M7k/vOQCEUYifKnwn/FmyyqIJLMCqtWT7HN+YFrpN1+rf
         a/3HmImpWhcppH95iEkABrYNaR/LQy4GZWfUlTjtiBTqcTtezx1sULD5qCfq9u/Ln1xD
         IKeglLtVxGOCwThBYbZg9JHayUPW//KO9aiiaS6yyXD3yx27fydCpSd1vtesSCNBLEPM
         BGbSH5mcI4KTfdTWBbncbexCsBxfXjcHGgmrDr91NYjvzfKaF5f+v/CuiP/SFyeaXoOz
         8I/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=x+tlmGCTQffoJAJ59dIRg7yQSWCd5WUCFuykrjOLls4=;
        b=dICR/E8GYn1xmh3Up4TVOsbulw7ABAyanO+/z5OZFvFdaoZ7ICWhDu8amBlSD1Xq/1
         QltaHHjmTheUpugIAVEM2oWBk5pYVPfwdS28VTJlre8lTiAsdS5O7F7LmymLXiotkzK+
         lY+IlmrndYML1+03AKJFGNuv3743nS392/vJeOpH2wR4gdnV9w0N+VhX8Z0/tB44Cgmi
         0eLE9aEYddUfw7yaPFUSZNSzuseNv8pVTNN2TutuI8vfVYjtANyQ3uSgBvQyXeZpMDsv
         yGKIjRFvCxEaw1aSlNAZrcHJxUZb2LEY78QcqkFKqseyy6hJYFmdA2wFaDFXY7D3a5TI
         GfNQ==
X-Gm-Message-State: APjAAAUNblTMuPgK+0dpEGGBDYiRTrz2zdsPTOOJMHwi1eVKtdQaPUaW
        2pIaN3T+pamSnEHEPT01NEuBGw==
X-Google-Smtp-Source: APXvYqy7tQUyJzt9ION7dasYlQo8JtEgA5jKviVfaqh8+aAA+D2N5abe2O+rgBXn4BsnUsv3xH442w==
X-Received: by 2002:ac8:3014:: with SMTP id f20mr132378514qte.69.1561422609413;
        Mon, 24 Jun 2019 17:30:09 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i17sm7995149qta.6.2019.06.24.17.30.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 17:30:09 -0700 (PDT)
Date:   Mon, 24 Jun 2019 17:30:05 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrey Ignatov <rdna@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Takshak Chahande <ctakshak@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Message-ID: <20190624173005.06430163@cakuba.netronome.com>
In-Reply-To: <6d44d265-7133-d191-beeb-c22dde73993f@fb.com>
References: <20190621223311.1380295-1-ctakshak@fb.com>
        <6fe292ee-fff0-119c-8524-e25783901167@iogearbox.net>
        <20190624145111.49176d8e@cakuba.netronome.com>
        <20190624221558.GA41600@rdna-mbp.dhcp.thefacebook.com>
        <20190624154309.5ef3357b@cakuba.netronome.com>
        <97b13eb6-43fb-8ee9-117d-a68f9825b866@fb.com>
        <20190624171641.73cd197d@cakuba.netronome.com>
        <6d44d265-7133-d191-beeb-c22dde73993f@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 00:21:57 +0000, Alexei Starovoitov wrote:
> On 6/24/19 5:16 PM, Jakub Kicinski wrote:
> > On Mon, 24 Jun 2019 23:38:11 +0000, Alexei Starovoitov wrote:  
> >> I don't think this patch should be penalized.
> >> I'd rather see we fix them all.  
> > 
> > So we are going to add this broken option just to remove it?
> > I don't understand.
> > I'm happy to spend the 15 minutes rewriting this if you don't
> > want to penalize Takshak.  
> 
> hmm. I don't understand the 'broken' part.
> The only issue I see that it could have been local vs global,
> but they all should have been local.

I don't think all of them.  Only --mapcompat and --bpffs.  bpffs could
be argued.  On mapcompat I must have not read the patch fully, I was
under the impression its a global libbpf flag :(

--json, --pretty, --nomount, --debug are global because they affect
global behaviour of bpftool.  The difference here is that we basically
add a syscall parameter as a global option.
