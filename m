Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FC1548452
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 12:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241352AbiFMJuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241134AbiFMJtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:49:36 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A9B19F90;
        Mon, 13 Jun 2022 02:49:18 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e66so5067850pgc.8;
        Mon, 13 Jun 2022 02:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mfp0GaooaweeJ/9PfaurVmtO8mS6bi3k5qu0JAcpnl4=;
        b=JbIQJE4lx1OmdVa9wYEHyxSfdI9oYZveEsZiO767Azm1A7stC+LIRlZjOOdsWs+PWK
         j4vK1fnjjdjT9xl+O7mHkQlLk5LfUtDJPKMwfGb0XSjEeGd2AJRnA5srPdPI5vev5qRr
         86mMaZlfUHVBmzVfZKNDqPONr8J8zjg+MTvGjp+lM6FWi/l8FPhXufCg4efWvI/xrddX
         QrkNMx7nJuJHzfeYeW4QvaUbQwvNYZ6w+gz2wrFzLoRPJZanEAn78QYuGOZo1hr49ftl
         wMwByAJH53G/dJUh4rSp3FQsHn1VCKMRo7jHpSEPBJL0mcxw2hNkUFSMM6mNDKVsrJel
         zRBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mfp0GaooaweeJ/9PfaurVmtO8mS6bi3k5qu0JAcpnl4=;
        b=y4b5ZfE3JQ6My4C/nqcb4ZPDfKkckmPueuzAnSFmrQjIrg2v1fzzjBmzWfp31RKaGV
         gou8KuqzamRkraSTnP8706TFceLxYSuZO7qhbR043ij+aRap1n8WMkHah52/qi+C+ieU
         orTiqJaI1095SE0kT5hmb9vOWIudncdBzdBxnLSPN0KhMGAMWRXPPzYENuRk9O0M9LrR
         CNRMEi55cuECGnsbLXjRFAzpBa+kYQpqwbFtYkUkNs3NWa/ebRgRbocIMjjF+Ed8XQsc
         WZpccMnTChkM//yY8n3ZE/Atj+f7Rnh4oZifqOm6fLaLmu2nAzegFhzTNltu/IEB51eC
         qlHA==
X-Gm-Message-State: AOAM532eQWROZiNj7DsYNxpyPigmC2+Zhj94tQzacS2TaaDLxVMl9rvp
        vORpOlaz2me3xQyypTtnOsVl1o3UHr8LvHH8E08sp9DtORoPAouF
X-Google-Smtp-Source: ABdhPJx7oo2z94E6bPUU7uJKPk43jYb2/nrM1BmJZT8qOtJr4y7frWCRhBMmtgOF/NcJAzk/yPKoFoaVWSkdLG+NhMI=
X-Received: by 2002:a17:903:2c7:b0:158:2f26:6016 with SMTP id
 s7-20020a17090302c700b001582f266016mr58514877plk.154.1655113747808; Mon, 13
 Jun 2022 02:49:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220610150923.583202-1-maciej.fijalkowski@intel.com> <20220610150923.583202-6-maciej.fijalkowski@intel.com>
In-Reply-To: <20220610150923.583202-6-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 13 Jun 2022 11:48:56 +0200
Message-ID: <CAJ8uoz2rWff3EwyRJ=6JOG_9phWVigq3FHzE6mUhCt_YmePdTw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/10] selftests: xsk: add missing close() on
 netns fd
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
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

On Fri, Jun 10, 2022 at 5:15 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Commit 1034b03e54ac ("selftests: xsk: Simplify cleanup of ifobjects") removed
> close on netns fd, which is not correct, so let us restore it.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index da8098f1b655..2499075fad82 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -1591,6 +1591,8 @@ static struct ifobject *ifobject_create(void)
>         if (!ifobj->umem)
>                 goto out_umem;
>
> +       ifobj->ns_fd = -1;
> +
>         return ifobj;
>
>  out_umem:
> @@ -1602,6 +1604,8 @@ static struct ifobject *ifobject_create(void)
>
>  static void ifobject_delete(struct ifobject *ifobj)
>  {
> +       if (ifobj->ns_fd != -1)
> +               close(ifobj->ns_fd);
>         free(ifobj->umem);
>         free(ifobj->xsk_arr);
>         free(ifobj);
> --
> 2.27.0
>
