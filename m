Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D18166C86
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 02:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgBUBxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 20:53:34 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34014 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729635AbgBUBxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 20:53:34 -0500
Received: by mail-pg1-f196.google.com with SMTP id j4so194588pgi.1;
        Thu, 20 Feb 2020 17:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o2r/RVnu6JO7pTVZiTaUWHa/HbQRPtHWj89M7roS6GI=;
        b=dSe6K11513cVUh9uiJyjLj34TB0NpRXV9jWK64RP00cgIjt3qqc6HQkoDQoLZ7WnFI
         c8XPUmdoI2MaUs5KJZ9VgZRBGff5f5dY3wy+JwqHr0oO8WgdyLGGE1yXuCOKqQlPZkPN
         SUDRtdhK0D2zl+87cC0UTSTN0yWCA0hsDGXqW936eaMkt14IT0gl2x+Lawh++5OVWsrP
         kAGzpLn5BHPSyQA03XePzwuyiUToUvu4Uu5/bcyacOmqJLy7OzMlR+HGNcfvKvhCFI84
         pl79+5uH56Ggx3FlTrpDSdHQbHZV+HIfu7YJ2SjyBkeosrmiLQBmfUMT9J88ry7H+Lmf
         T8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o2r/RVnu6JO7pTVZiTaUWHa/HbQRPtHWj89M7roS6GI=;
        b=bZeh9nADuZ2IGJbBtBIliYVK71ju6NONx4ZMdC4rVD8eViwMY0Kg3d5Pf2k74Ktmyb
         HKGeXWeacSfVxa18RAIBdUoPQBNNQiHmmHXfo9twc0UfmaVvpuKUGb5urxyFVWFfqI3e
         +6iYWIaFk3bHptfdRMFWTDgFCHrNgcZaPpJRkI3uwe+dZAi12VL7f2UDdzEmG1EuH70A
         osSsESqtlw4TDbD77HRI7TOUomyRcx7Ziqj9nRjxkVE8aNvL/Yol/B4b81dmH2MICPax
         ljcQnVx2DQWxc63/SG7RywNoHiopm3XHuUYWHoMIVUlA47rpqUfZ3JBLpbBF5HzSTsnC
         K3HQ==
X-Gm-Message-State: APjAAAUS5+/eWvPqWVkV0iKd85NITdWk8T22oFx1p7lyxegznilEZMHc
        7ZoB6rfN80+tvTyYfSS+7lQ=
X-Google-Smtp-Source: APXvYqzklwtFzRgCK6l8Rv9BCooVoZ0TxHTxFsqJ8lu06D1D0B8VejWjSx2VM3SxUOgk3C3Mo1dkSQ==
X-Received: by 2002:a63:18d:: with SMTP id 135mr10183325pgb.32.1582250013375;
        Thu, 20 Feb 2020 17:53:33 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::5:f03d])
        by smtp.gmail.com with ESMTPSA id b25sm849061pfo.38.2020.02.20.17.53.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Feb 2020 17:53:32 -0800 (PST)
Date:   Thu, 20 Feb 2020 17:53:30 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: Re: [PATCH bpf-next v5 0/3] libbpf: Add support for dynamic program
 attach target
Message-ID: <20200221015328.czidhbsau2xmyg7e@ast-mbp>
References: <158220517358.127661.1514720920408191215.stgit@xdp-tutorial>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158220517358.127661.1514720920408191215.stgit@xdp-tutorial>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 01:26:13PM +0000, Eelco Chaudron wrote:
> Currently when you want to attach a trace program to a bpf program
> the section name needs to match the tracepoint/function semantics.
> 
> However the addition of the bpf_program__set_attach_target() API
> allows you to specify the tracepoint/function dynamically.

Applied, Thanks
