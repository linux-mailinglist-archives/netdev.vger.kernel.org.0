Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF64752A8C4
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 19:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351284AbiEQRBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 13:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351306AbiEQRA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 13:00:59 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A3F3FDAC;
        Tue, 17 May 2022 10:00:58 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id bs17so15068503qkb.0;
        Tue, 17 May 2022 10:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JQfz7/9xIwZXm9owxDLXdrtXLr0FcC/lv49DpFzTm/w=;
        b=KllF1yFDNMuYt8/7qrB0ktpdb+81T1SrApDtTOsVrHcMhq673CWem5wB4dLaly0uZB
         +0b4yDMOD+PUQ5PUeT61AfniwPm6jJfRNoaOTY5PEjT0a9Zg/UNuJSXbnp1OYnAyMJoP
         TPBwE6Vby5NWvsqTEhzb5xMRstgMpq4DPchwpx8a3w+nx1JkXIlYJovY04+TZyWe3C3+
         q+13GBcAXHa3Vh5Ef4VX6ka0TN4khAHdDou8zfQJTxA4MtI+OlWkN1I3I/8uDUOgh9sw
         G/AKWxJRpSKTEW1s42ASC1Vx0/5WdwiCAQkg9PFZaR/DArVMzvsPsXAflz+ftBLUMdKY
         EqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JQfz7/9xIwZXm9owxDLXdrtXLr0FcC/lv49DpFzTm/w=;
        b=iEYhtJ9aNb0k8yiu/8ySLZC1deUiBpcrFScu82H16PJc332AIIf8zF1tT0K2pdBXLP
         NgEQSFdK71HR4WpXhcR8BGMPkI/uFZ3a6v4epieRzAEtqueTkSqW1ETiXOXL3gRba7x9
         0otk5lwY/K+5P1eRhAI7fM1vITSwUR5gSL8d/bokQttg7UnyJzmVDLCXK2a7AY/PtgHR
         AX5lf6RWt/L2gE4oWSYERtZeC4XG92zTXNGmmbQ7MZplU+rOFJ14PSIKImH96Ahigyex
         Le9aJEbFtbF4aYjpa7ssM0sFugIcH8hnMGMaVSSNXTI8MHCS3dxcozxcAIS7ah4KO44B
         R79Q==
X-Gm-Message-State: AOAM533pBW9U/qmOf8NeXuwgxlvmBFQu4c37qo97CIOWSc712rOSYetw
        bh7My829KqfQCUg7nfxuJ+BQ5I1A1CgIfN0k6k4=
X-Google-Smtp-Source: ABdhPJyc0I91BWWjtZVgl+EUrAbG6Tfb9o74K2EpzYJFWxb9b781DfjS9ZrI6ajXliDgmZM28LTPoF7yVklrLtOEFRQ=
X-Received: by 2002:a05:620a:28c7:b0:6a0:5de3:e6 with SMTP id
 l7-20020a05620a28c700b006a05de300e6mr17521955qkp.464.1652806857719; Tue, 17
 May 2022 10:00:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
 <20220513224827.662254-2-mathew.j.martineau@linux.intel.com>
 <20220517010730.mmv6u2h25xyz4uwl@kafai-mbp.dhcp.thefacebook.com> <CA+WQbwvHidwt0ua=g67CJfmjtCow8SCvZp4Sz=2AZa+ocDxnpg@mail.gmail.com>
In-Reply-To: <CA+WQbwvHidwt0ua=g67CJfmjtCow8SCvZp4Sz=2AZa+ocDxnpg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 17 May 2022 10:00:46 -0700
Message-ID: <CAADnVQJ8V-B0GvOsQg1m37ij2nGJbzemB9p46o1PG4VSnf0kSg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/7] bpf: add bpf_skc_to_mptcp_sock_proto
To:     Geliang Tang <geliangtang@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 10:26 PM Geliang Tang <geliangtang@gmail.com> wrote=
:
>
> Martin KaFai Lau <kafai@fb.com> =E4=BA=8E2022=E5=B9=B45=E6=9C=8817=E6=97=
=A5=E5=91=A8=E4=BA=8C 09:07=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Fri, May 13, 2022 at 03:48:21PM -0700, Mat Martineau wrote:
> > [ ... ]
> >
> > > diff --git a/include/net/mptcp.h b/include/net/mptcp.h
> > > index 8b1afd6f5cc4..2ba09de955c7 100644
> > > --- a/include/net/mptcp.h
> > > +++ b/include/net/mptcp.h
> > > @@ -284,4 +284,10 @@ static inline int mptcpv6_init(void) { return 0;=
 }
> > >  static inline void mptcpv6_handle_mapped(struct sock *sk, bool mappe=
d) { }
> > >  #endif
> > >
> > > +#if defined(CONFIG_MPTCP) && defined(CONFIG_BPF_SYSCALL)
> > > +struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk);
> > Can this be inline ?
>
> This function can't be inline since it uses struct mptcp_subflow_context.
>
> mptcp_subflow_context is defined in net/mptcp/protocol.h, and we don't
> want to export it to user space in net/mptcp/protocol.h.

The above function can be made static inline in a header file.
That doesn't automatically expose it to user space.
