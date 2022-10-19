Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20E160524A
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiJSVyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiJSVyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:54:19 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4C6193EDA;
        Wed, 19 Oct 2022 14:54:18 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1364357a691so22338000fac.7;
        Wed, 19 Oct 2022 14:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YJ+gcKy3+ICExSUxeGNVeYxwKRMLEpodZAR4x+ytUmQ=;
        b=dDJ0JQ93bZPq2dQ6HHs4BM3P7y7x3ex4Udx/f3oV107fIAGRqCqiUAK4T6/mclRUTL
         k6VXDsJCo+3VOLCazldKjjHM+lJ8QOakQMzFCtwXIigRqYJpthjSWHrUjldK/XyX2l/l
         iKOv53hDmtNPRgk4yKn68UV8V+zEdg05C0xPy9JrWNc2IUpCk3ldysiIHF2222Zrz4cS
         LK6W0jibjbXYKBBw5Q1xhDVsALV0y/74K62EaojRNgGc4MO64kHLT6PSIH7xOjVPiab9
         gfOe9o2Am9w2RJuip/fqKfHsokGMnFI4g5rBGqa+6SEQ0g8xiGnd7jFNXe8RRo8UaCED
         3oVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YJ+gcKy3+ICExSUxeGNVeYxwKRMLEpodZAR4x+ytUmQ=;
        b=t8MYsd9bKlXGZ1qcaUanYvjenaWaE0tEG1+HRBHk2XUmCKfWDdU4m4FPZ1p8AEQKBc
         lxuL3Z4gGAeVRysVdkAcRTw/APDtjHHOfhmgHBlM9Tz0Y2F/r5O9/dynp9fuNPsAmxqz
         BoRieBjWaqqjzE5cWLvVB+pLnccizBd+Spj6cMjcWc0S0ydNl9YU1l95Sd56/lJRiclf
         mFMVZl/8tcsmu3Qn6pHvEvPjeoOJdQTgj7fqFA/AdmBH8kZCG5olDlU4jDt+mjjf9kjc
         aQoziRHL7xastWW7A0DdX+IZPnh+BuOY27GxBO7NC60pYcN5kytAfeAEQsDrNlWh/o/7
         KzcA==
X-Gm-Message-State: ACrzQf2tZt4Hp0RBXl50/PJwuOtrCQxM4GMGIG00RJ+4K7Rl/0qiSo0u
        qmJT5CkmqRlH+aewE9q8TIthAUvItXozS7Uw5oSLv5gI66Y=
X-Google-Smtp-Source: AMsMyM6xVu23n1WzC5jBi8l3VQrxg/vVtSsZD3E9sLqVSYnql7UC+za1j/nF8djhGSf29UDOy4693nVx540OzUxovGg=
X-Received: by 2002:a05:6870:9614:b0:11d:3906:18fc with SMTP id
 d20-20020a056870961400b0011d390618fcmr23560049oaq.190.1666216457895; Wed, 19
 Oct 2022 14:54:17 -0700 (PDT)
MIME-Version: 1.0
References: <20221019180735.161388-1-aleksei.kodanev@bell-sw.com> <20221019180735.161388-2-aleksei.kodanev@bell-sw.com>
In-Reply-To: <20221019180735.161388-2-aleksei.kodanev@bell-sw.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 19 Oct 2022 17:26:48 -0400
Message-ID: <CADvbK_edAKXgrQUgcPMxkVFADOnPuyU3+Dzumi_3MubYoHvvRg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] sctp: remove unnecessary NULL check in sctp_ulpq_tail_event()
To:     Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org
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

On Wed, Oct 19, 2022 at 2:33 PM Alexey Kodanev
<aleksei.kodanev@bell-sw.com> wrote:
>
> After commit 013b96ec6461 ("sctp: Pass sk_buff_head explicitly to
> sctp_ulpq_tail_event().") there is one more unneeded check of
> skb_list for NULL.
>
> Detected using the static analysis tool - Svace.
> Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
> ---
>  net/sctp/ulpqueue.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
> index 24960dcb6a21..b05daafd369a 100644
> --- a/net/sctp/ulpqueue.c
> +++ b/net/sctp/ulpqueue.c
> @@ -256,10 +256,7 @@ int sctp_ulpq_tail_event(struct sctp_ulpq *ulpq, struct sk_buff_head *skb_list)
>         return 1;
>
>  out_free:
> -       if (skb_list)
> -               sctp_queue_purge_ulpevents(skb_list);
> -       else
> -               sctp_ulpevent_free(event);
> +       sctp_queue_purge_ulpevents(skb_list);
>
>         return 0;
>  }
> --
> 2.25.1
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
