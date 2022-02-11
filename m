Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415E24B2BAB
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 18:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352100AbiBKRXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 12:23:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352048AbiBKRXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 12:23:02 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34C0EB
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:23:00 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id q8so10281964oiw.7
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RMceFYwu1Z7FylRi/vquOuUKEuhpJXw4PqAupYCh6vw=;
        b=hEtueQAUS0iO+9GnW1QKdY3fNXIcZb4a/Y3AiDJnNvYVnKq2lcxZKE8VREF6Tvffh9
         03KSzmmbjFEVvFWX1vna00BpVooaseDtFYD+KaOhuBR7tPak78Tt+piAzXkS0vApwj+s
         CVqTNMwN80d6tf+mNe0yciLDF0/h5y6cXv9gVEBCXdh7pnLVo5fZhApxNvZwmd1yUocS
         96Iu8F7TwpcisOnVjmOXhGbhY2IHRGH9MgQekZ/0Wt+CtoghOYiv/fbQvLXrSh975xrD
         2gj2je5Z0d8GSb/pj3zaeTmqNUiywYYy6Xev+Zw4ndPS9G9MOcD+56lblT47AqrZxhOM
         33GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RMceFYwu1Z7FylRi/vquOuUKEuhpJXw4PqAupYCh6vw=;
        b=hzgi4yM1750KMVXjAJXJ3MVimIhQ5P+dwm8U6PMk6g+3Ke2LNO+gFZNWJj60od7mlh
         SkOMDdB7ONauuM5dfwLvn8zR5CABnA31CuDhr+2E2JQ0ZxC+yfkInYJyuHGh1Qxu2M8K
         KvEH5iUFxUSgtKnU9IC7orypjcUeusAwcuACHzsNHYF/kn8U5MbGt27WaXirDxVQY+Hl
         4Az2uyGMg4s5PmAkboo3fGIeEdP9JHBaqsXKiadKN0cM3v4Fw+Ny+EBOkcP4n6yom6SP
         ZrIKWmKA7VzVKnY+SBg8hX7pGl+YXHkqThvtajrDZfnd0oyEbTlA4fy4C9bRyfC7uWDK
         2zug==
X-Gm-Message-State: AOAM532JhxDO6Aq0QLVAqGrlM9HhnG9O+q9cJUwy8IgBjdvR3s8lxFUY
        ney2+eZ1LbayfH4XeGR/imo=
X-Google-Smtp-Source: ABdhPJxf5FV4flw1bkS2B9oaf1paOmwy2yY/dfRP6r+xPFvvo06zLj9FTS09Trx26XbdF9l6yFFHhQ==
X-Received: by 2002:a05:6808:f91:: with SMTP id o17mr10223oiw.337.1644600180266;
        Fri, 11 Feb 2022 09:23:00 -0800 (PST)
Received: from t14s.localdomain ([177.220.174.74])
        by smtp.gmail.com with ESMTPSA id e16sm9428747otr.11.2022.02.11.09.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 09:23:00 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 2ED3615EA1F; Fri, 11 Feb 2022 14:22:58 -0300 (-03)
Date:   Fri, 11 Feb 2022 14:22:58 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Oz Shlomo <ozsh@nvidia.com>,
        Eelco Chaudron <echaudro@redhat.com>
Subject: Re: [PATCH net-next] net/sched: act_police: more accurate MTU
 policing
Message-ID: <YgabcluXWaQY9tVv@t14s.localdomain>
References: <876d597a0ff55f6ba786f73c5a9fd9eb8d597a03.1644514748.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <876d597a0ff55f6ba786f73c5a9fd9eb8d597a03.1644514748.git.dcaratti@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 06:56:08PM +0100, Davide Caratti wrote:
> in current Linux, MTU policing does not take into account that packets at
> the TC ingress have the L2 header pulled. Thus, the same TC police action
> (with the same value of tcfp_mtu) behaves differently for ingress/egress.
> In addition, the full GSO size is compared to tcfp_mtu: as a consequence,
> the policer drops GSO packets even when individual segments have the L2 +
> L3 + L4 + payload length below the configured valued of tcfp_mtu.
> 
> Improve the accuracy of MTU policing as follows:
>  - account for mac_len for non-GSO packets at TC ingress.
>  - compare MTU threshold with the segmented size for GSO packets.
> Also, add a kselftest that verifies the correct behavior.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
