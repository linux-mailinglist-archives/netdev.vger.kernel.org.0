Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47624EFA07
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351332AbiDASmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 14:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbiDASms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 14:42:48 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9541C9452;
        Fri,  1 Apr 2022 11:40:58 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e18so2597262ilr.2;
        Fri, 01 Apr 2022 11:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WnSfOIIrQ569jvdkUOc3ipz9bsS0h+Elh+Wg1h7JaDM=;
        b=btkJ3EZxQ+YOnXOWUVRCuNDLblYuGow2eu0es+XNgP14XxCgrHs7P5fh3N3r0bRIFb
         KtLiNxsNcL3u8MzwUH4yo/g3qr+iotaQ5Bof18saQayBSPeH2sHlGePWe0BH2pT2eRWE
         adTLRgDtMG86ZutUyp7VooLWA23OruWT2oD7uQWMA7kkTFTuSObyxilmk/Toz5m4moFD
         liV6AjQ/xI+M7tTBUnkk99AARVHFr5o//28FXpJJgSFl8/mtBLhOagHv2c7RvAoHYz1p
         axPhctOK+ZCArARUbULkx2JiBde245hEbSI91203vHC6nc2Gqisjjymi9q/vKCifV8HX
         jBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WnSfOIIrQ569jvdkUOc3ipz9bsS0h+Elh+Wg1h7JaDM=;
        b=uV2k5Kmy8CSufxCLUIX37YcHbIYwVOKIWd/loloSH9e1ToSVs/6csvj0Cb+Y3ZUfHM
         RQg4V6tlhIiTdj4cyhS9arl5qJn7zamMEAMFFwcM+kWDc+SZoOhYUndc0G0UgH3wUEnc
         LvCp74a3FKvMUalZuO45kkcOFRwgBK31af7WEM7dlL0pn+4NNVbDMnV1i27vH2EKJvNt
         jG6AwB+Jz/ChisRtDF6EcjjJC/RuhFjpl3rsYVoDLbSGmgxOh5hY/xRSpyNFn+Yjgwuy
         JnPZ3vIwmX3eAmim3Mj9nI9RXWVZsKCN2AL8mER70cOxUna3yI/+sM20zcA3Vn1iKh33
         uDaw==
X-Gm-Message-State: AOAM5300g/1KYYa1cwste3E2p8PPsQatJ/shk0NS08KDA3L/215eNWU8
        k4v9psYFURZdKkwsJAzauTl/8I7aMfiScEMLSRA=
X-Google-Smtp-Source: ABdhPJzWePUsjnKnCYeo7uJLve9zX9a8s5tWYlQPfGXw8PuLzddIrsbbXhvr1+eNC6vb7nxPd/BBqFqE3KJV8ixUTQE=
X-Received: by 2002:a05:6e02:1562:b0:2c9:cb97:9a4 with SMTP id
 k2-20020a056e02156200b002c9cb9709a4mr518682ilu.71.1648838458296; Fri, 01 Apr
 2022 11:40:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220331154555.422506-1-milan@mdaverde.com> <20220331154555.422506-2-milan@mdaverde.com>
 <f2f8634f-7921-dc7d-e5cb-571ea82f487d@isovalent.com>
In-Reply-To: <f2f8634f-7921-dc7d-e5cb-571ea82f487d@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Apr 2022 11:40:47 -0700
Message-ID: <CAEf4BzbYmOVRvCU-f6XbNJQb_ptM+BPjAcMD9XEN_wTKRHUWsg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf/bpftool: add syscall prog type
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Milan Landaverde <milan@mdaverde.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Fri, Apr 1, 2022 at 9:04 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2022-03-31 11:45 UTC-0400 ~ Milan Landaverde <milan@mdaverde.com>
> > In addition to displaying the program type in bpftool prog show
> > this enables us to be able to query bpf_prog_type_syscall
> > availability through feature probe as well as see
> > which helpers are available in those programs (such as
> > bpf_sys_bpf and bpf_sys_close)
> >
> > Signed-off-by: Milan Landaverde <milan@mdaverde.com>
> > ---
> >  tools/bpf/bpftool/prog.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> > index bc4e05542c2b..8643b37d4e43 100644
> > --- a/tools/bpf/bpftool/prog.c
> > +++ b/tools/bpf/bpftool/prog.c
> > @@ -68,6 +68,7 @@ const char * const prog_type_name[] = {
> >       [BPF_PROG_TYPE_EXT]                     = "ext",
> >       [BPF_PROG_TYPE_LSM]                     = "lsm",
> >       [BPF_PROG_TYPE_SK_LOOKUP]               = "sk_lookup",
> > +     [BPF_PROG_TYPE_SYSCALL]                 = "syscall",
> >  };
> >
> >  const size_t prog_type_name_size = ARRAY_SIZE(prog_type_name);
>
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>
>
> Thanks! This one should have been caught by CI :/. Instead it complains
> when you add it. This is because BPF_PROG_TYPE_SYSCALL in the UAPI
> header has a comment next to it, and the regex used in
> tools/testing/selftests/bpf/test_bpftool_synctypes.py to extract the
> program types does not account for it. The fix should be:
>
> ------
> diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> index 6bf21e47882a..cd239cbfd80c 100755
> --- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> +++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> @@ -180,7 +180,7 @@ class FileExtractor(object):
>          @enum_name: name of the enum to parse
>          """
>          start_marker = re.compile(f'enum {enum_name} {{\n')
> -        pattern = re.compile('^\s*(BPF_\w+),?$')
> +        pattern = re.compile('^\s*(BPF_\w+),?( /\* .* \*/)?$')

small nit: do you need those spaces inside /* and */? why make
unnecessary assumptions about proper formatting? ;)

>          end_marker = re.compile('^};')
>          parser = BlockParser(self.reader)
>          parser.search_block(start_marker)
> ------
>
> I can submit this separately as a patch.
>
> Quentin
