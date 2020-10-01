Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5B7280A88
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 00:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733002AbgJAWuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 18:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbgJAWuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 18:50:20 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BB4C0613D0;
        Thu,  1 Oct 2020 15:50:19 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id m5so573335lfp.7;
        Thu, 01 Oct 2020 15:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y9to2P3MnQRvS65OIRtoj6JaR6yWu9/hCXhnCwnQDpI=;
        b=Ctk/8DqQbYbAZoIDhsyfGcrJxXpnnRJPi3JU7jN7NMbtzqHLRdf7apus3vnhwvZ7iD
         rAVn3MFoEPUiM0ym9VJaeQ2pb4cGtSxGVq1k72wi7E97eaLOQCfdi4BW0dsPKbASoZb9
         gy20zTZCtZVJFmMQXYwnQY1PdVnjN0QhoV1kbW77dX3YSaclxJViELchhGnMSHnI88Z3
         zKfd0w88rybxA3B8vtgJWDhTqT7J69DT1Wp6TVxvl85tpTByuU4VK48bp1Yal2k5mmmK
         Nu1tPEWu32R6UDrDfPow0LD1BwBZXcHI0Qbw0uLXqE48bcxLs7WkhOze6C4uELQVbYgS
         qlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y9to2P3MnQRvS65OIRtoj6JaR6yWu9/hCXhnCwnQDpI=;
        b=gHJqs1p0c9ZsxqtM1U1JgevhZgxzQFQkIxvuA2kUpA2DEaw+jTfVxbkqouaCpBR6di
         WxEqqnFso/a5h75Qp4xpG8ZwpnBUHjCUyGkeeaAab5ZhZjUOymdlFfK+YcV3+GoVuqws
         IaN3523dKPcz/BOCVf2fwkKD9+oDqCRx3AEEINOKeE2CIghK+dqdI0KzXcLVyyZj2T+s
         R8cfnZDSw8KLfowDBsbs7HKVAFilsBj17iao45j1n3WbMsNUKfjGmserC2tkJ5kLG2TY
         ntkd+S7QHJ9t5vI8EZQGncFNsC5JviKJArVaurVPHekfS8lTjIwPNlceqojX0qQ7+mGX
         mBrA==
X-Gm-Message-State: AOAM530FY9yWfTzZpfJyGrHqvhcMnfQT1QJH1yQ5ajeiSNMBfXeoHoFi
        PWHeCSK7Ouxk5TFUnkNc05sm9Jaf6mUsImjka0Q=
X-Google-Smtp-Source: ABdhPJzT8eeJd0Fp8nEjNQfsKYTrNpb+4WAOydutlRAXuuvr6+RElNRiGTXQyWJ+CSYe8JhDEiYnRWwDlUPx/YdbFBE=
X-Received: by 2002:a19:50d:: with SMTP id 13mr3053620lff.500.1601592617492;
 Thu, 01 Oct 2020 15:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201001020504.18151-1-bimmy.pujari@intel.com>
 <20201001020504.18151-2-bimmy.pujari@intel.com> <20201001053501.mp6uqtan2bkhdgck@ast-mbp.dhcp.thefacebook.com>
 <BY5PR11MB4354F2C9189C169C0CE40A9B86300@BY5PR11MB4354.namprd11.prod.outlook.com>
In-Reply-To: <BY5PR11MB4354F2C9189C169C0CE40A9B86300@BY5PR11MB4354.namprd11.prod.outlook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 1 Oct 2020 15:50:05 -0700
Message-ID: <CAADnVQJmmY_HER23=3bxCrrsbJoNs1Ue__P24KHj3YY1EkzuKQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 2/2] selftests/bpf: Selftest for real time helper
To:     "Pujari, Bimmy" <bimmy.pujari@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>, "maze@google.com" <maze@google.com>,
        "Nikravesh, Ashkan" <ashkan.nikravesh@intel.com>,
        "Alvarez, Daniel A" <daniel.a.alvarez@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 1, 2020 at 2:52 PM Pujari, Bimmy <bimmy.pujari@intel.com> wrote:
>
> Thanks everyone for putting your valuable time to review these patches. Can any one from you suggest the best way to test this function in selftest?

Don't bother. This helper is no go.

Please trim your replies next time and do not top post.
