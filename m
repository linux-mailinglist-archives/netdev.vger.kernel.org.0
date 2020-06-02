Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3EE1EC242
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 20:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgFBS7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 14:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgFBS7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 14:59:43 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096F5C08C5C0;
        Tue,  2 Jun 2020 11:59:42 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id z9so3261381ljh.13;
        Tue, 02 Jun 2020 11:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4wlP6EmtH4oErIgXGovLEskNL+GxMqCU3konRptVK3k=;
        b=sumtyCzei8Pjdzsz7A+65BufAOnGjSn7bXljLJG3EfFMc7f52rrjjfNXHPdeVuU9G4
         aHZRb8vwf+FxEjoCuZEY2yTJgSxlkZGZpf0LJLRqTyf23JHaYNJGX1V+gnkgt+zvyLej
         KDWeGkZDDEE0eQLk8LksGLMDiIaTORAHIfyPPNfE3EdiUavHBoA2FRQANdfbLcTCjzja
         ToGi5GpQDQF437Cfs2dNqa47JlDVA+pmKWpYFVlVMBmKAuz9r0gHj3aqRdTm1ZZiEW2i
         Z2kP0gWTZ262NrBCSFfKtmsfrP+dVO09Ji7X/sjlpiI4o3VaW5d+4a7eEFbyRi0zoJKz
         Ie6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4wlP6EmtH4oErIgXGovLEskNL+GxMqCU3konRptVK3k=;
        b=dr10k6vPqDPfUWguOv7pUb9yJe/5lOgJZong+elVZNEISwSkK9tndMX5DkGCKbAX6t
         JtjnxXkzEL09H05BEvTPpi7gNwMPgDBmmIgY5jBj6oGE6TQUrnmjgsUiowbLJ12Ly6f4
         S9n9A7MH2pBA3R4Xbefgv5oEVvyB+9RTzzBKaKMNBZx1iaSzH22kS/d0gYO5qM643jXe
         31WmSgY+RnWyI+ifVi5keXeQH5HFtNc9W5JBsKGyK8o6hWimV4Ls9h6xPAxxxRVVeXrF
         hILB93o14CDbsku3yU7n5mx7h51hh7pnkjRGa5ksvEkJLLUjWNSDLd9VNiXxjVU/JtT8
         EOYA==
X-Gm-Message-State: AOAM530fsDJs5ddxxOTL/D0Jhj44lcVJXLk4/36ZjxH+mrh3l6HnRPAh
        pKUYn0pBpms0j+ApdWBeHrEiqy5vuo6+Q3sUoUI=
X-Google-Smtp-Source: ABdhPJzH12bEzKSHdbnMVE5IzldD5WdVAI5z+UMCRZWK2Bwk7apQ7kloIaZKFxiyXf5PLXc6sB+0NaxWSZk2+ff3VWA=
X-Received: by 2002:a2e:974a:: with SMTP id f10mr253335ljj.283.1591124381387;
 Tue, 02 Jun 2020 11:59:41 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1591108731.git.daniel@iogearbox.net>
In-Reply-To: <cover.1591108731.git.daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 2 Jun 2020 11:59:30 -0700
Message-ID: <CAADnVQLFB1Y9PP3NtZvrFRyRTsTW=nHuGOhqYqC+mgghfh4rEQ@mail.gmail.com>
Subject: Re: [PATCH bpf 0/3] Fix csum unnecessary on bpf_skb_adjust_room
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 7:58 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> This series fixes an issue originally reported by Lorenz Bauer where using
> the bpf_skb_adjust_room() helper hid a checksum bug since it wasn't adjusting
> CHECKSUM_UNNECESSARY's skb->csum_level after decap. The fix is two-fold:
>  i) We do a safe reset in bpf_skb_adjust_room() to CHECKSUM_NONE with an opt-
>     out flag BPF_F_ADJ_ROOM_NO_CSUM_RESET.
> ii) We add a new bpf_csum_level() for the latter in order to allow users to
>     manually inc/dec the skb->csum_level when needed.
> The series is rebased against latest bpf-next tree. It can be applied there,
> or to bpf after the merge win sync from net-next.

Applied. Thanks
