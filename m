Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F7E5507EA
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 03:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiFSB4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 21:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiFSB4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 21:56:17 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F76DEF8;
        Sat, 18 Jun 2022 18:56:16 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id h23so15046727ejj.12;
        Sat, 18 Jun 2022 18:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8vfH2d4aXGbYFoRQ1C1A/di4tJyn3VCLYTTFPUgdEmo=;
        b=PjmUHsk4ejduQshsd6kONL41Dl1HLFaqnNxEEmMZeAZtG8CIN3DxeyXOalYmUDvOnR
         vm4hZ/xgdo/lWIIFNZm7n3AG/VoLrMg/ldey2tnEDJqvwo+smU3dGcuLK7iyFE9WoUYC
         3z2aUZBInv1XRnJLn0v61a3ne81w0Gms9Q6EnMbz9dXz7yacPznWFd2j0v28INyroCuL
         2BbAMaPDoNSXT9KmZ5gvm1IuEUIAU0TzHRn0gMapFQ0LQeo8Q32JPp3XdIY2ZmQIJULL
         8dnsvGztGyFVRLew6UOYSGckLgO9swgaY+T/55Du8YvL0EtHBVkCFSdZDuYWUQCqxaG1
         grRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8vfH2d4aXGbYFoRQ1C1A/di4tJyn3VCLYTTFPUgdEmo=;
        b=4mkmvuvKpQfuvJBFbLRf9q0YXH9sL60Qg4RDJHb0HwOWbVD9kOwR7UwFh6qX95YN2O
         SbquwYj3s1UFogUmJEzJ/AC63/nVgPpuj3/QPJVe2Kpb2m88/WwgPk0YpaN2qlYJuMwa
         z3q9eZLyCnPNtONsXu2TSdwSFO5Fb+BYM2YWCRGCOwO/lYUcro4uNDaLfyd/aD6o4LET
         f09Y9HyooetkpX6B8bNgQUQyaRiSkQ+GKez4vonfOBtoflVks/qvnQvtjG8lYjPSgIY2
         7fZ/xZu16lDL2cdBUm4CggESUjlDAbSjLmeJj06roZ7wmrFVCVuM0S4qIqzQWUl6FfTQ
         1EDg==
X-Gm-Message-State: AJIora9sbAFoYgsc+a2QZxKqcnRfb2nrEDBiPBjqiSqA4iUiOWdlnvvv
        nKg/B+bnoG72xa6C9gnzFUdrLDXakYU6DAPfgJ0=
X-Google-Smtp-Source: AGRyM1veday674gQan5uJCUawQeX3lk/gOhXxOiac8cW0YQbkKg2rcfykeGnYh0kCH++BZB5BGgEoqxnWailGE4idMI=
X-Received: by 2002:a17:906:74ca:b0:712:585:751c with SMTP id
 z10-20020a17090674ca00b007120585751cmr14879127ejl.739.1655603774897; Sat, 18
 Jun 2022 18:56:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220614084930.43276-1-nashuiliang@gmail.com> <62ad50fa9d42d_24b34208d6@john.notmuch>
 <CACueBy7NqRszA3tCOvLhfi1OraUrL_GD9YZ9XOPNHzbR1=+z7g@mail.gmail.com> <Yq5A4Cln4qeTaAeM@krava>
In-Reply-To: <Yq5A4Cln4qeTaAeM@krava>
From:   chuang <nashuiliang@gmail.com>
Date:   Sun, 19 Jun 2022 09:56:03 +0800
Message-ID: <CACueBy4Nr+rqJjZ3guBimd6t36V5B3CBp6_oZVMRzLvMZoTRpg@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Remove kprobe_event on failed kprobe_open_legacy
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jingren Zhou <zhoujingren@didiglobal.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Sun, Jun 19, 2022 at 5:17 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> just curious.. is that because of ipmodify flag on ftrace_ops?
> AFAICS that be a poblem just for kretprobes, cc-ing Masami
>

Yes, the core reason is caused by ipmodify flag (not only for kretprobes).
Before commit 0bc11ed5ab60 ("kprobes: Allow kprobes coexist with
livepatch"), it's very easy to trigger this problem.
The kprobe has other problems and is communicating with Masami.

With this fix, whenever an error is returned after
add_kprobe_event_legacy(), this guarantees cleanup of the kprobe
event.
