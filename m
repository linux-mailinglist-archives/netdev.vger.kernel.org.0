Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FF357F526
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 15:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbiGXNHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 09:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235991AbiGXNG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 09:06:57 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5756713F88;
        Sun, 24 Jul 2022 06:06:54 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-10d867a8358so11653733fac.10;
        Sun, 24 Jul 2022 06:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I3gfoVoanMe4gA4YnpGshVf32heT0CKZ5wuTqz0UZy0=;
        b=C5m1Z2i8OtQVyB+jQYACBV8/s1FeF3Tjwc+QiaUQiB6H5K/DKb8k6GTM7LsLuru1Wv
         AQN5NghjwLKaXT+pzAiqg6xAPqPYtEbJZarw+T/gX/ZK9pEBVZxBMJT2Uce6LgoddSqp
         /7/atbfsWG9q/4VX3UYeuYJcZYLiKOq6B+nPyz/iUiFIA2rtCiRzo0mjz5KjjzbzmtYM
         OE+sCBt9RwN42q/kJb8efz6uiwj3IjDeDFvLPh9ogG1Fm/IpD2TJrQx+JVG3DFofP9gO
         G1DVaftT7nXbwHwAcbxMvDwVe2O3E1+iZ3iaWwe2OozxGYyBmZxtXMXgCRRw8EQL3zan
         MG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I3gfoVoanMe4gA4YnpGshVf32heT0CKZ5wuTqz0UZy0=;
        b=3EEZDbP17ohfw/BjrqziirbgIEQ0vCLTSDWiFtYfHpBjc46Cy3ZBp6Y3lwnxyivAqn
         t2aaxB3dbzxvWLpjTTkn3ymdwgu3tt8PlQEW4M/pUbT1gLJG9I4L81haoSziRQ6wa3jy
         quNmUWxurV8IAYwUZrTCWT0tk27K3hzhYUb9jQlwpFDH46/JybiLk6/LSyU9TOXMjFI5
         iBxiEftcR9lblaji8qnzXx0q1XH3BEzd6JR6uOSyhqUnLxSadnBj4tirToKcgIKWojeG
         eTqXwe7eIqkUhhdc2v1YgYERgqWOs66x6wGvkeuM/QSgnCmwrSx6G/HuXEF3mdFBhoGJ
         5xwg==
X-Gm-Message-State: AJIora+KS7tFfxKn5MSG6jMmesAP3MbManJg6NS//dJzpnXDnky6Mq9A
        QgghiyCOixsglXfdJ5ovpW4O6NbCQvk=
X-Google-Smtp-Source: AGRyM1u9kl3bNtKadWoK/4nbf/sj7b9aIZ9thyhhSCYznvdV+QG4XYsLXbEDti/EruGPHOb4l45vhg==
X-Received: by 2002:a05:6870:79e:b0:101:48bf:7fa8 with SMTP id en30-20020a056870079e00b0010148bf7fa8mr11806523oab.291.1658668012836;
        Sun, 24 Jul 2022 06:06:52 -0700 (PDT)
Received: from t14s.localdomain ([2804:d59:ad0f:1800:4914:cce5:a4fb:5a6d])
        by smtp.gmail.com with ESMTPSA id 63-20020a9d0dc5000000b0061c94e755d8sm2411255ots.58.2022.07.24.06.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 06:06:52 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 1C46135B3A7; Sun, 24 Jul 2022 10:06:50 -0300 (-03)
Date:   Sun, 24 Jul 2022 10:06:50 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCHv2 net] Documentation: fix sctp_wmem in ip-sysctl.rst
Message-ID: <Yt1D6l5FTpIVIltV@t14s.localdomain>
References: <eb4af790717c41995cd8bee67686d69e6fbb141d.1658414146.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb4af790717c41995cd8bee67686d69e6fbb141d.1658414146.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 10:35:46AM -0400, Xin Long wrote:
> Since commit 1033990ac5b2 ("sctp: implement memory accounting on tx path"),
> SCTP has supported memory accounting on tx path where 'sctp_wmem' is used
> by sk_wmem_schedule(). So we should fix the description for this option in
> ip-sysctl.rst accordingly.
> 
> v1->v2:
>   - Improve the description as Marcelo suggested.
> 
> Fixes: 1033990ac5b2 ("sctp: implement memory accounting on tx path")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
