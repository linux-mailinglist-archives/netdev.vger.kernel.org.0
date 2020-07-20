Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FE8227289
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 00:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgGTW5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 18:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGTW5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 18:57:31 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD06C061794;
        Mon, 20 Jul 2020 15:57:31 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g67so11029288pgc.8;
        Mon, 20 Jul 2020 15:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LNJnhW9ZrTp6uqZIei/d2TycMtbwqPFcj8c4aIh219s=;
        b=h1AYU+tLXYVtRPLpacb60Yaw77cMglfc3+wdlNNq5dZrUSiQmhicDeA2Xr8ButgWH+
         3qFVucDT4BRwmqPpuVv8WfOMJsulvhltYa+jgGptgopujVKAaAYPH8+xAWjr8zVQ8L9t
         r1oyhxRbWjnk2d41ym3hmOAaleCqHWEYT7RZVzWUuPc+upTTaPgPoZpKg1oGnvlI25dS
         ya10UnnN3LxfQ5yUeoUbZwibbLLefm8akyEEwniBTAmTfSgH+MBuZmhTsy22Wm+VHvxn
         WW75GwRjUyYc8BsLKsDuNf+vbPEbXlAoXYYyCsZw8mStDUdTubs7JfCkzXsWIFUz1MVy
         UgAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LNJnhW9ZrTp6uqZIei/d2TycMtbwqPFcj8c4aIh219s=;
        b=sZpog3qUz2G8fCZcTsrJ9txkzye2cS19MREaDdfHO5bmvqMXtDPjdPKi8iMSIICL1a
         wk8RzRbNurKOPLI9J09T/0UwISwu0dWBfrb9TXg1gm12aPdjtRGX91hUHL70RMydGx4a
         KCeaO5yt3OQTtqxd3lup9OBzwAZMkrUKxW6p4MYdMg775VWsCBp9G/IJ7pENNWKRkFoG
         Ki3hp78qUlRFbQ5QxiQ5hiNaoQSjcb8SfD/m4Wepku1ZXoMJUJnJNvKAPoHnuabax853
         Yo+HOsKuJOdaK/8GyH8C8LYOBRTFOOdBKF8NdJpCSntkk2a7f7X+Mp423pPfhEiYCWsZ
         io1A==
X-Gm-Message-State: AOAM530oUY8X1AMCqLTI48mrHZGKd9GmzMU/b26XAEEZkAU3gP5m7spS
        cwuFC6PnXzSLMtMIzs+nOzY=
X-Google-Smtp-Source: ABdhPJwIO7LQDwT0cv97smz/Dy9/oF/3KFGYq4Rviujb1Bf45cSPFqLqinL4mDq4f/yEXNdOtpXNNQ==
X-Received: by 2002:a05:6a00:1586:: with SMTP id u6mr21094121pfk.147.1595285850894;
        Mon, 20 Jul 2020 15:57:30 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e3b])
        by smtp.gmail.com with ESMTPSA id m26sm17839333pff.84.2020.07.20.15.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 15:57:30 -0700 (PDT)
Date:   Mon, 20 Jul 2020 15:57:27 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/6] bpf: support attaching freplace programs
 to multiple attach points
Message-ID: <20200720225727.zs7x63u3f3kw3apt@ast-mbp.dhcp.thefacebook.com>
References: <159481853923.454654.12184603524310603480.stgit@toke.dk>
 <159481854255.454654.15065796817034016611.stgit@toke.dk>
 <20200715204406.vt64vgvzsbr6kolm@ast-mbp.dhcp.thefacebook.com>
 <87mu3zentu.fsf@toke.dk>
 <20200717020507.jpxxe4dbc2watsfh@ast-mbp.dhcp.thefacebook.com>
 <87imemct2d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87imemct2d.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 12:52:10PM +0200, Toke Høiland-Jørgensen wrote:
> 
> > It's a circular reference, obviously.
> > Need to think through the complications and locking.
> 
> Yup, will do so when I get back to this. One other implication of this
> change: If we make the linked_prog completely dynamic you can no longer
> do:
> 
> link_fd = bpf_raw_tracepoint_open(prog);
> close(link_fd);
> link_fd = bpf_raw_tracepoint_open(prog):
> 
> since after that close(), the original linked_prog will be gone. Unless
> we always leave at least one linked_prog alive? But then we can't
> guarantee that it's the target that was supplied on program load if it
> was reattached. Is that acceptable?

I think both options are fine.
We can start with simple case where close would destroy the last link
and if somebody complains we can keep 'at least one alive'.
This is such low level implementation detail that I don't think any user
can reliably count on it staying this way.
