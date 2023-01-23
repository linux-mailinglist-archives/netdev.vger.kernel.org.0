Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060536786ED
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbjAWT5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbjAWT5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:57:15 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6824C31E06;
        Mon, 23 Jan 2023 11:57:12 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id p15so12651076ybu.7;
        Mon, 23 Jan 2023 11:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SwFSmFGSFvE63rqhLRsLE3ZOCxLB6AoBtvuCcpWo5X8=;
        b=knJxXvV8gVvBgVUZ8Vbf87jAW925ydkct3ER9LLx/vVbA7YnpiAhOwxpPBprIWp7au
         mR744qCROAzms8MVlqQ4VkBYIpxkidQYlvJ4RMT+R8lAroG0UGoTSi0w3cwOJwOiEyxu
         SgCasKekH0bN7MLkuK2jcH3A4LYPRJPc41Xk6XfHkDHtUfi31YJekrCJM09NyoDoyHGr
         n6d0fGIU8j+J/ewdrMj0wmCNkSE3teDftpfN4QWnIvVn5O+tM1OTM2dXwIS7eaK92vTr
         sVf/VkokEL2iFr4mhL6v4aAqnYIREBp/YdGY8U0wiVMooM/nAInOfouXCCF2eFPz/Twd
         9c5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SwFSmFGSFvE63rqhLRsLE3ZOCxLB6AoBtvuCcpWo5X8=;
        b=crj7Rknxhx5Dwtmf8SYdJQHQ2SKvgyM5mHhnlFv8lO0/NfWdTY1Id2oslMygOAZMUj
         QiA1MVBaiyagTJ+YBRAPFy8OvkrivyTHTvDwDD/unYW12tNRlB17CU0FAysk3w1ou85V
         RDmJ0qNyk2hSg1vwic6tZMrcnTUcEspG4NYaFOBlx2NrRIzNPzRwMx7Im1FxibeNUZs/
         FObYaZlQV1u6jPhAWJNlYgB5dKs45EsnsvbFnvQaZQrHZR8Gq8iOCg2sKWMFnKG3fgSl
         JsK2//xW4iY15pTeZVHJr/OkYkxSlxMJp+0yO3U/rPO3JXrfBDtiO5xcondQoPYN/6vy
         5UGg==
X-Gm-Message-State: AFqh2kqoIPhCTaa/OxIuTziybNfZNtWsRuDBpdbMlMKy9ayrnFGH58N3
        Kery8y7Dvlmr75DHFqBG2Y+mALSCAl/VHOusDxc=
X-Google-Smtp-Source: AMrXdXvAYZvJAXQ644lutxCGbxm9JqtOOqaFGseeOmlfUtHr9+XbFkUrBmNclWzlq6nlDxOj3TwFqkQhTSJNZnqwakY=
X-Received: by 2002:a25:ac0b:0:b0:801:525c:6725 with SMTP id
 w11-20020a25ac0b000000b00801525c6725mr1213011ybi.446.1674503831571; Mon, 23
 Jan 2023 11:57:11 -0800 (PST)
MIME-Version: 1.0
References: <9fcd182f1099f86c6661f3717f63712ddd1c676c.1674496737.git.marcelo.leitner@gmail.com>
In-Reply-To: <9fcd182f1099f86c6661f3717f63712ddd1c676c.1674496737.git.marcelo.leitner@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 23 Jan 2023 14:57:00 -0500
Message-ID: <CADvbK_coTyeDDyRHeUVPxWzx+bWXhMKZEXLr_YVwr08T=3u10Q@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fail if no bound addresses can be used for a
 given scope
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 1:00 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> Currently, if you bind the socket to something like:
>         servaddr.sin6_family = AF_INET6;
>         servaddr.sin6_port = htons(0);
>         servaddr.sin6_scope_id = 0;
>         inet_pton(AF_INET6, "::1", &servaddr.sin6_addr);
>
> And then request a connect to:
>         connaddr.sin6_family = AF_INET6;
>         connaddr.sin6_port = htons(20000);
>         connaddr.sin6_scope_id = if_nametoindex("lo");
>         inet_pton(AF_INET6, "fe88::1", &connaddr.sin6_addr);
>
> What the stack does is:
>  - bind the socket
>  - create a new asoc
>  - to handle the connect
>    - copy the addresses that can be used for the given scope
>    - try to connect
>
> But the copy returns 0 addresses, and the effect is that it ends up
> trying to connect as if the socket wasn't bound, which is not the
> desired behavior. This unexpected behavior also allows KASLR leaks
> through SCTP diag interface.
>
> The fix here then is, if when trying to copy the addresses that can
> be used for the scope used in connect() it returns 0 addresses, bail
> out. This is what TCP does with a similar reproducer.
>
> Reported-by: Pietro Borrello <borrello@diag.uniroma1.it>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/bind_addr.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
> index 59e653b528b1faec6c6fcf73f0dd42633880e08d..6b95d3ba8fe1cecf4d75956bf87546b1f1a81c4f 100644
> --- a/net/sctp/bind_addr.c
> +++ b/net/sctp/bind_addr.c
> @@ -73,6 +73,12 @@ int sctp_bind_addr_copy(struct net *net, struct sctp_bind_addr *dest,
>                 }
>         }
>
> +       /* If somehow no addresses were found that can be used with this
> +        * scope, it's an error.
> +        */
> +       if (list_empty(&dest->address_list))
> +               error = -ENETUNREACH;
> +
>  out:
>         if (error)
>                 sctp_bind_addr_clean(dest);
> --
> 2.39.0
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
