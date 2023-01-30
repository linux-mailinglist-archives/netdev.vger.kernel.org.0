Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A453681679
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbjA3Qcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237553AbjA3Qck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:32:40 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF384390D;
        Mon, 30 Jan 2023 08:32:39 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-163ba2b7c38so3855945fac.4;
        Mon, 30 Jan 2023 08:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mlhjVywI8R445RbMDqO/wi5Zp38Al4pNkK1C17RVc/U=;
        b=fSmhHC2X7VRlXDpivBZd6giBBSZAyNS04cCWw86Z9CVAahbzXJVPrIrpB7Rivayn8M
         Xu/9t5db0EkIBjkjm47tg+4xYJtTCtygmkphE/TurEKVOrl9AnxU5O9GPKSFcUI/YvPb
         snMVClWAqEiqLGSsRg5xOU497OqJdz1C5iB9odkyhs7UEXqK/bCwV6Sj8blkz+5GnaoY
         1ORg5+a0/Az5vznCv7JggwXyQs69cTDiW/QKiqMD1qA3SRN/792RJunJxI5lsGbdwoyw
         PQTcVEvK0q0bg/cCTW1rztjikeDBQYxGumIeTkUJ/SigAdP7VIyU3k600XAoDRxzO7Mi
         8rfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mlhjVywI8R445RbMDqO/wi5Zp38Al4pNkK1C17RVc/U=;
        b=YTHEYfvkN2HAbLH4tTACsOEQBe7DPmam25S2PZ3dufrv/Ut0OTBldur3jOXyZl4WSY
         Q/5f214w743QrVFNbMNt3vMXcYKuGjqsJ9w0Ox5x9WnLV19tTr+3VW9CuOtgPov3UU3/
         ZlvPB9Y2aKZVYDbxErQA1hkegLpGx/RZoWDrtQcob3Up8ZLku2n421GZF3Z4JjYM/Rr9
         BRxQAvDYKcRmtReqy+LrvH115W69yX1JVX8EP1o6wZE56DXlUlnxH0H8wr8rstUruN1I
         t7FXrZ31S1L2aq/j9kAgU4EKafzrr8Y9h1jtPnBetx602eLKlo69xtxc5Mv8FUMKy7zu
         9qdQ==
X-Gm-Message-State: AFqh2kr5P5LaWj9Mf8xGQcOVxuNcgBv9GlfrXYtfPHNNSGqnLfA5LNFP
        rw5AlLhjx9EYJsm+mdeAlNk=
X-Google-Smtp-Source: AMrXdXvnleIjrd0Rbe1Mte85SybvWGkDn4/I0NFdLJLvEZhrXKaqdKj8dsmKXkLAYNmkVUUe7DpsLg==
X-Received: by 2002:a05:6870:331e:b0:15f:c4f5:65a7 with SMTP id x30-20020a056870331e00b0015fc4f565a7mr22153599oae.52.1675096358449;
        Mon, 30 Jan 2023 08:32:38 -0800 (PST)
Received: from t14s.localdomain ([177.92.48.160])
        by smtp.gmail.com with ESMTPSA id ld24-20020a0568702b1800b00163b3472300sm1482007oab.2.2023.01.30.08.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 08:32:37 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id A85E44AFFEE; Mon, 30 Jan 2023 13:32:35 -0300 (-03)
Date:   Mon, 30 Jan 2023 13:32:35 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: do not check hb_timer.expires when resetting
 hb_timer
Message-ID: <Y9fxI5Ai5/1J8LFh@t14s.localdomain>
References: <d958c06985713ec84049a2d5664879802710179a.1675095933.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d958c06985713ec84049a2d5664879802710179a.1675095933.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:25:33AM -0500, Xin Long wrote:
> It tries to avoid the frequently hb_timer refresh in commit ba6f5e33bdbb
> ("sctp: avoid refreshing heartbeat timer too often"), and it only allows
> mod_timer when the new expires is after hb_timer.expires. It means even
> a much shorter interval for hb timer gets applied, it will have to wait
> until the current hb timer to time out.
> 
> In sctp_do_8_2_transport_strike(), when a transport enters PF state, it
> expects to update the hb timer to resend a heartbeat every rto after
> calling sctp_transport_reset_hb_timer(), which will not work as the
> change mentioned above.
> 
> The frequently hb_timer refresh was caused by sctp_transport_reset_timers()
> called in sctp_outq_flush() and it was already removed in the commit above.
> So we don't have to check hb_timer.expires when resetting hb_timer as it is
> now not called very often.
> 
> Fixes: ba6f5e33bdbb ("sctp: avoid refreshing heartbeat timer too often")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
