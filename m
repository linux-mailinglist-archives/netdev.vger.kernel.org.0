Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2E31285EA
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 01:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfLUAOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 19:14:51 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37265 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfLUAOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 19:14:50 -0500
Received: by mail-pf1-f195.google.com with SMTP id p14so6095123pfn.4;
        Fri, 20 Dec 2019 16:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nK44Vr89NmZuCyKIbfoLiolS9Qcsu/KC0oIH3rPXT5c=;
        b=jsux9Xc3joFGB8ZlvywCjA0Uw7aAkLfrXmmrNv7CFqXaQWYeMQWbBmPMlBm97j/sy3
         2nHQaVBBOaqT2IKDgihPPZciaPw20A4hszRFJTzfViwPu5yPNAhsDQZ04cTmtpEBpywN
         7O7xwGWywtLjqOP0fR7pKtkr+9zcwscQAjdOiMpWaHUxHJ0bpe13Vrlo7bhO7MFqivcx
         AYlchn6O8WV1NvQufe1+PGdSHbP038ke7yR/KgKEmhqaAg0QpGN2bn8BAxfiKPeNudFI
         E+EYU/G5i+fWZTf/IyIol+2jlbop7JnmRZIhRVP1YHAdbK8323un1AkkwpMRVvgY1i5b
         Vl6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nK44Vr89NmZuCyKIbfoLiolS9Qcsu/KC0oIH3rPXT5c=;
        b=UgepwZ6BZNl2mGitdLi7ufEUAby4apsF5/ERRPEx1OzzXFq3SjNqm/veIvcG2b+N9z
         1SEKnoAL81HpIzrA0563rfpsDGSP+ROltXbVG1OjswhYZQERVtn3LKUV+EHegI8fTICy
         c0XdkhfPnhUuUoXrLQvxsYN87nshEh6SsE8U+HxkyTwPFT2D0s+Z6BlSxBjCz2jjRmp7
         ISLADbD3hMIyRu6wr3t/KzlqK34TXk3z18LKd+jixNZKNtqPVTp+zzcX2JcK4ILF4SMq
         xWe6BLgSzfP1aE8DaJYxR1GuyGonlJGFZB5fb4zKu5BDS2p9UFSSE9hajQ9CojkUc2O/
         8V/g==
X-Gm-Message-State: APjAAAXW9rSFv+G4Oa8V9FcFy7sXRJAr+iSc2R8w5GfsXNrsUFqnl6uT
        jRR8wJOf+zZ5v2z9ZEPDOn8=
X-Google-Smtp-Source: APXvYqw1t1XKHOd3Pj1zFSqZYU+eFGFsqZ0jpXBUqVnV/uVG7RcWT2Rh+y8tiVTbt4PIPNCTgrftSQ==
X-Received: by 2002:a63:ec0a:: with SMTP id j10mr17827496pgh.178.1576887289838;
        Fri, 20 Dec 2019 16:14:49 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:827d])
        by smtp.gmail.com with ESMTPSA id w11sm9043762pfi.77.2019.12.20.16.14.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Dec 2019 16:14:49 -0800 (PST)
Date:   Fri, 20 Dec 2019 16:14:47 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Maciek =?utf-8?Q?Fija=C5=82kowski?= 
        <maciejromanfijalkowski@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: Re: [PATCH bpf] samples/bpf: xdp_redirect_cpu fix missing tracepoint
 attach
Message-ID: <20191221001446.6zjqrgmbnec7tsyu@ast-mbp.dhcp.thefacebook.com>
References: <157685877642.26195.2798780195186786841.stgit@firesoul>
 <CAEf4BzbnL43Dka+qsTmUYvEnqSHOS72J+eE1qOnHCQdMAkR4Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbnL43Dka+qsTmUYvEnqSHOS72J+eE1qOnHCQdMAkR4Zg@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 09:44:42AM -0800, Andrii Nakryiko wrote:
> On Fri, Dec 20, 2019 at 8:19 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > When sample xdp_redirect_cpu was converted to use libbpf, the
> > tracepoints used by this sample were not getting attached automatically
> > like with bpf_load.c. The BPF-maps was still getting loaded, thus
> > nobody notice that the tracepoints were not updating these maps.
> >
> > This fix doesn't use the new skeleton code, as this bug was introduced
> > in v5.1 and stable might want to backport this. E.g. Red Hat QA uses
> > this sample as part of their testing.
> >
> > Fixes: bbaf6029c49c ("samples/bpf: Convert XDP samples to libbpf usage")
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied to bpf-next. Thanks
