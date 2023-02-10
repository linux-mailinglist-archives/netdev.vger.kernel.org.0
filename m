Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8C16916AF
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 03:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjBJCbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 21:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBJCbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 21:31:37 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472536E9B9
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 18:31:33 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id o42so299400qvo.13
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 18:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LGngK6rabHobn1eHHpScaqU9Hmwj5zMXVdN85Qyqpeg=;
        b=lAWjrQu9Qz91Z9MNl0dzNuJOPFItZNfm/+KbjXZw4ob/oELQX66MN6wmtwc52oILtq
         zB3ei8ggwS6xLZ4jvvvkbjvKG4SXD0ZxP6O2mUBDBxeXZWxERPgJO7haiQPJEDnEJ3Dl
         i3b9EUMfgtVXG/8833o/1cRqdbM861wcARAWWff8QAd300ZpHwLMHwm988HucszDgzTe
         bWXzLRU56ah0VD4OJyVdzeRr4FkcRwztnasl2R/ow5dtUXWOUOeEiaNg8DcxjKh7nR6D
         1o/LMC7GNA4/84fSejPs6EFv3AfyqBconlEySOopmDQP8utKwBYQJffrc5LJqo3bXwHd
         qxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGngK6rabHobn1eHHpScaqU9Hmwj5zMXVdN85Qyqpeg=;
        b=SU0p1tAWyzx24L9yAbLCO/Rccdp/fdoO2SStsHPdyJDYTI9FXgtSM1UMVAOTriITDd
         Z0Fplg7WTSivASqtbYdSAp2eUlDojT0tcfcby2EIZSlGKVcUa3L4UNazIjfcx9YhI6l0
         TFZfqLlZxCnrLYb86/FrzNtXJk7fWB6BTaE5yMbfRv5AEypd2diO+nfrs2odE3JOP/l1
         H6KMYkyD4Dk3kPwW+zzn9SLNYTXj9q/jNQIrUzrA7Yx5LH/7L+uKfPrtxbyT1/QqhZOI
         e0nOfHn+SY714sGz775nVqMMKuGniabObXAy851iMnbR6fNmS1hLRtzgngijbyBhVuNG
         syYg==
X-Gm-Message-State: AO0yUKVATIYZj1IlDFGw95hRGcggoRsZc/INMbIkcvqWkpJ+PTQhEeRd
        lqTuJviH8TgbjFT356G42gk=
X-Google-Smtp-Source: AK7set8+lM4n7Wasn4DaORTAtUooYHP56xUh1wt9jui4PjXlEn25HD++rbb9gQtnO2q5WU9Na98QOw==
X-Received: by 2002:a05:6214:21a8:b0:537:6e23:f34c with SMTP id t8-20020a05621421a800b005376e23f34cmr20576101qvc.39.1675996292229;
        Thu, 09 Feb 2023 18:31:32 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id u63-20020a379242000000b00731c30ac2e8sm2611986qkd.74.2023.02.09.18.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 18:31:31 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id CE7D94C1EC4; Thu,  9 Feb 2023 18:31:30 -0800 (PST)
Date:   Thu, 9 Feb 2023 18:31:30 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next v3 1/9] net/sched: optimize action stats api
 calls
Message-ID: <20230210023130.kloxv3cu2wcdvetg@t14s.localdomain>
References: <20230206135442.15671-1-ozsh@nvidia.com>
 <20230206135442.15671-2-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206135442.15671-2-ozsh@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 03:54:34PM +0200, Oz Shlomo wrote:
> Currently the hw action stats update is called from tcf_exts_hw_stats_update,
> when a tc filter is dumped, and from tcf_action_copy_stats, when a hw
> action is dumped.
> However, the tcf_action_copy_stats is also called from tcf_action_dump.
> As such, the hw action stats update cb is called 3 times for every
> tc flower filter dump.
> 
> Move the tc action hw stats update from tcf_action_copy_stats to
> tcf_dump_walker to update the hw action stats when tc action is dumped.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
