Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A276215E5
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiKHOQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbiKHOQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:16:32 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C3370569
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:16:30 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id f27so38995063eje.1
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 06:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5+moI56BVGSpSI7NRhPLKmv5unmEMYSjuvcZ0Mb6yFY=;
        b=n3e/n0SREsvjcgxpduufQ2rlt6toRTNhJcM8JrQeukA4/U+lHZXB9kDA1SzJCqKoT0
         uzMvbfUa4yBKehzvw6CpQ0/+RGtr98Q+GlVJCLx7kMTL0j/ch+07wVR8eDcezjZh5Pu3
         mu9Gv5XMXYG476C5JuGodX3JWHum1X4GtHuB/Wg1pTUINexkXK3cTo3XxG9Q+wFobBm4
         C1F1DY0WLuplv+d+DUK/C9xZay8xesM+HxCckaUeaF4KNzMkLOGtg9QILXHcmmRTjbdk
         EhsEldZIGzvL90+ifSyKLnLUn58oegecqiu/pPXG8zkAv6DAG6WT530qcPmhcgujw9Td
         VQ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5+moI56BVGSpSI7NRhPLKmv5unmEMYSjuvcZ0Mb6yFY=;
        b=cBBit8yp7hfviyIMhvv2JTbgc5/hbuRRNX7x/fNS8LfH3pE2jw0j3CwhoCKz6etTBm
         X0fseseZSvuGK2R4AEZHrr57emOQf8wUUT5sy92abKB4alIUhxZOUdIKIgB4W8Zt3ELM
         oWaqUkrB6UWWe5z9Yw0aYUx8G9k62kC95VmaQsl191TDwh5MbpM8f6BICzv5xp3XEfM3
         f5+acZS8KUk5+z7Rh1oYdJWjqtBsnIj8E8Q5P8OzdAAZ989ZsQoQsoLjIi+yB9p1HQsc
         uNOYaij3/m0YXstRC2Ol/4c9ojkGX0jbnXF74ZbEnDXyU3Gydnv57jPWHLBSdN946nc6
         bC0w==
X-Gm-Message-State: ANoB5pnb8WLNhuh/k1azztl4K0qKb5jalordsmWUDF0XAV0oO/4mHyC6
        VCmF9vs79YBMy7BCbzwAjIk=
X-Google-Smtp-Source: AA0mqf5SczXPn92m5329abAbaWcF8Ig8g9SjzgZbZxIP09gzKT9hyIOvyA4RobWfnegiHsbjDU7fTA==
X-Received: by 2002:a17:906:7e55:b0:7ae:4bfc:ef45 with SMTP id z21-20020a1709067e5500b007ae4bfcef45mr15823740ejr.94.1667916989236;
        Tue, 08 Nov 2022 06:16:29 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906308100b007a97a616f3fsm4678111ejv.196.2022.11.08.06.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 06:16:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date:   Tue, 8 Nov 2022 16:16:26 +0200
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 01/15] bridge: switchdev: Let device drivers
 determine FDB offload indication
Message-ID: <20221108141626.eymqr6lomtppeaek@skbuf>
References: <cover.1667902754.git.petrm@nvidia.com>
 <b266dcf6d647684a10984d12f98549f93fd378ab.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b266dcf6d647684a10984d12f98549f93fd378ab.1667902754.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 11:47:07AM +0100, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Currently, FDB entries that are notified to the bridge via
> 'SWITCHDEV_FDB_ADD_TO_BRIDGE' are always marked as offloaded. With MAB
> enabled, this will no longer be universally true. Device drivers will
> report locked FDB entries to the bridge to let it know that the
> corresponding hosts required authorization, but it does not mean that
> these entries are necessarily programmed in the underlying hardware.
> 
> Solve this by determining the offload indication based of the
> 'offloaded' bit in the FDB notification.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
