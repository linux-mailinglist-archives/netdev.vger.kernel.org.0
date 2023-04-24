Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A186EC8E6
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 11:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjDXJbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 05:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjDXJbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 05:31:38 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6EC1B9
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 02:31:37 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b51fd2972so3406190b3a.3
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 02:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682328697; x=1684920697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KplVVQX38N9H79+bqqQBXd9Y6M76ehACq1l5GC4o9dw=;
        b=VDmNx5xRos8imhx20RMvDNejnBaZMtylEnL41ZtaHDj6FObo0foFKoLxbkDRQNC1C0
         2LMKsXafk5NHTL8FdDkf5N5wE5hA042GHwsOhb4EXbWVqGoza+XFJY16vmWKu7mDR5Dh
         Q+VHc+NDgeJHbP5BLh5govzIl9Pn3KJ8J+YypGHx/gqv77iINdSan0bilXQ68MgOm+Px
         h+bIh1w7JGtFnHb68WradDqylPay/7aTnkCIQfPLDhJQkj2O/Ah0z4SIT6g99nyJiPHK
         QAoVP27UT5aQVw19uczpUMS2rGzEcBXyPVQ9hXVP0MhEADiRytZ5IhHNl5L6oGvDPYtC
         Khpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682328697; x=1684920697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KplVVQX38N9H79+bqqQBXd9Y6M76ehACq1l5GC4o9dw=;
        b=ji7lHbQOk95KoL3GHYnDTYtAy327Jgxj/e6ue0qdYJ15Ma0eBOuVVzRM2jT7HXP9Aj
         v7Pw0PUj7cu6LxoLaGVhFaiKXTjRMZ6wBaE5isJDGPd8nUpw45DX1fYC3mZp94UOWVjZ
         9bYzv3XWU4YuP/mP/Pogedo5mbCL+T5+iuwqEJmZnlctdK1kcOHLbmB84bIm1WiZQ+cm
         DMPtA3G039qId0+ksafH5JsV0LVCsKPhxr2HRD6vjBJG6sI0Tdye1Cn2pfona2YBsCRP
         B8Z59PtplmbmUchqUW18axqwmPhx1j9yo72jUF5CKJsweFeN+vRrXWTxibi/ExDEzOLB
         3x3A==
X-Gm-Message-State: AAQBX9dhwoaM0M1pVBSJVNOnDdj/YY8L88WvzdJUWxFXLP5NukX2xFk9
        8KW0CbnKPvJxF5Z2oCx97vQ=
X-Google-Smtp-Source: AKy350Z48RZ4mfEV+HLCcAtTPW1WZEv6onpSojBbirLcYeEisMMUXFGSiWgAJeqNa0TR+CLSEn31dQ==
X-Received: by 2002:a05:6a20:8f0d:b0:ef:5f:3c15 with SMTP id b13-20020a056a208f0d00b000ef005f3c15mr17409272pzk.47.1682328697451;
        Mon, 24 Apr 2023 02:31:37 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s14-20020a056a00194e00b00627ed4e23e0sm7030039pfk.101.2023.04.24.02.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 02:31:36 -0700 (PDT)
Date:   Mon, 24 Apr 2023 17:31:32 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v4 4/5] Add ndo_hwtstamp_get/set support to bond
 driver
Message-ID: <ZEZMdKBBxg5cQ/Mg@Laptop-X1>
References: <20230423032849.285441-1-glipus@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423032849.285441-1-glipus@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 22, 2023 at 09:28:49PM -0600, Maxim Georgiev wrote:
> This patch changes bonding net driver to use the newly
> introduced ndo_hwtstamp_get/set API to pass hw timestamp
> requests to underlying NIC drivers in case if these drivers
> implement ndo_hwtstamp_get/set functions. Otherwise VLAN subsystem

nit, Otherwise Bonding subsystem...

others look good to me.

Thanks
Hangbin
