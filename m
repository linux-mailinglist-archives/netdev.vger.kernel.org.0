Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBB533FDEC
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 04:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhCRDwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 23:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhCRDwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 23:52:15 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB3FC06174A;
        Wed, 17 Mar 2021 20:52:15 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so2400587pjg.5;
        Wed, 17 Mar 2021 20:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/oLx7NM4vYtrFdlY5asuY4jHZJRuqIH4ymrQ9zXa+Ec=;
        b=MSck7bwJG+DFpt3DqnHj4zddf3qWXQiZNHG9NaTbAhT5zvzUku1ioFABGXtAczDbHW
         zvEXLlQ2P0vVi6XYTfAopr5P0Pyp/IIbKlXmWXGdj82V48k2KzvuXnxUIJe7g30r5WfE
         0+ojX0jPby/xxZguSjpHLHvKB4czaOwbbxX28VmzjdRjTfbtgwPBx6K/VJqTcOPb0Npg
         3/bGS17bYi2RpNaQoB83riKrI2QkjceSiu/8uIgd4daD0pD+mvvC/XdCV4AXIjwDp9Xn
         Izq/FrPGHvvlV7hmsjcJtvIaezKhq8otdbqV3kMe5DGcvQIxngYRYYQNCI4UqlKQ73Uu
         PCsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/oLx7NM4vYtrFdlY5asuY4jHZJRuqIH4ymrQ9zXa+Ec=;
        b=XocChtehZPOKN1SYv1jpI/J57wBOTJONI+nwMsy78WAbLJxRrjOD7ZBpuzxQgOpE7p
         Tk/4uxbYZL+wP+CTW31ggDOQgBPk1jsM8aL5k+8vCONipG9jR+LS7P5eIV7hQxUIe1IV
         XAGM50QAk4YHt+oRuS/tYB59937QFKl65aAVBHbPcDZRMAYFw1xSHr0UoqOWXsBv8SIH
         ViJXjNzSTYZIfT9oS7NI3/smiE5QNskgHusIiCzEKP0OtdFahvhLdxjR4yGL+MKcouRj
         Z65VsE8B7USpz3ee8QwzM6aBZUvitUMMO9dtxhkXU5cTjW+dDBplGf+O2PULWW/eGIy4
         uZ8Q==
X-Gm-Message-State: AOAM533NmWM8+lyFM194dSzDQ86Huz3HCbO2Mlc1nYsBMD2/WaGjyWfg
        pmj8f5Y2SFP+wfMkH48Tutw=
X-Google-Smtp-Source: ABdhPJwdPzgHhvlz2jM5RrfzZCK7GSNyTMHqxM9ZXqAndj/EhVGV8dEXTXmYvs5aZOYUZwscbhjWJQ==
X-Received: by 2002:a17:90a:ba05:: with SMTP id s5mr2151817pjr.194.1616039534840;
        Wed, 17 Mar 2021 20:52:14 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fv9sm569715pjb.23.2021.03.17.20.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 20:52:14 -0700 (PDT)
Date:   Thu, 18 Mar 2021 11:52:00 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bjorn@kernel.org
Subject: Re: [PATCHv2 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210318035200.GB2900@Leo-laptop-t470s>
References: <20210309101321.2138655-1-liuhangbin@gmail.com>
 <20210309101321.2138655-3-liuhangbin@gmail.com>
 <87r1kec7ih.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r1kec7ih.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 01:03:02PM +0100, Toke Høiland-Jørgensen wrote:
> FYI, this no longer applies to bpf-next due to Björn's refactor in
> commit: ee75aef23afe ("bpf, xdp: Restructure redirect actions")

Thanks Toke, I need to see how to get the map via map_id, does
bpf_map_get_curr_or_next() works? Should I call bpf_map_put() after using?

The ri->flags = flags also need to be add back as we need to use the flags
value.

This looks like an opposite of Björn's restructure...

And I have expected another rebase after Lorenzo's "bpf: devmap: move drop
error path to devmap for XDP_REDIRECT"

> 
> Also, two small nits below:

Thanks, I will fix them if there is a way to do the rebase.

Hangbin
