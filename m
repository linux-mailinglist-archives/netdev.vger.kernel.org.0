Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB064E646B
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350582AbiCXNw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345162AbiCXNwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:52:24 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8813DDF4
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:50:51 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id i11so4768228plr.1
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1J7pI9E1RPNbg01jjlXE8tEOMGCqQLktqNWgtWgena0=;
        b=OiSGNjUGRl7Xq/ctMvip+k80mZgjF6zs8xCI2X/4p8j+IUSvO3IvqaXa+SWWP+konb
         S/TDlntkvW8x8RerH6nPmL4Vf4MHmVuuk8yWuyz8VK4BbMBUtB2CcAxeWq+B2MZdI9rS
         ku8Oc7QXIYe0hdDoPwmuF6tzmxER5AcfNPky1x3QE1j/gytc6JJTZztK/lLACZGWJ2Nc
         svuzKLInjue0EOGEaRAQjqNGCNnx+fRkEgU2sWsyKRxRKO+xc31YVSutU01joT3RDkRM
         qjhf+1ktxIPl4YVfbieCCLTdo2bbFg0FsE6IAe41XBejuiKulCC+g5tTYuwJ8QL8RaCb
         /rkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1J7pI9E1RPNbg01jjlXE8tEOMGCqQLktqNWgtWgena0=;
        b=GsJiC12qb6ruyb4ygthbcS/uby4ogYns6jOg0NMN+fF0IVHXZUF/2nYIcxgVzKcWjD
         3tiufL+p2susL85Uf5pOI9rvLZduOp/IkkULOxLZ7bNx6euQw13H9Xrg7N/759GOGAxQ
         wou22G4oeu87xbzKfMbKWEIqn7x2ZCekkLH3ZDqiEKr6qBiLzB8s/vzLq6uYlMpyu9ZY
         wYs6QQl6K3KAu8RJwIgX4eaWfnT9v+JWkJ+ALu/EOkhOsgeYZvbJdS2qvJVSMA28v0Az
         q/J3ShEmA6iGEMU3yg2qe0GxGOEeTZGKx2WCAQIT48jiXnYmZ889KR8IeobMJER32U32
         GpgA==
X-Gm-Message-State: AOAM530G/xduYNxvKLF0DF/xvwhdoOEqWzPIkW3U6pih5dgl3zVePQCv
        p7j+J5B1cDgzCpN3LoPjadQ=
X-Google-Smtp-Source: ABdhPJx4Ye5MRBiKHBLAsO4xFWiRP7S/AVkVgUI3+ZFKM+hJMoRHRPF2JmvZdf364mrRN8Fgkft0uQ==
X-Received: by 2002:a17:902:ec90:b0:154:5c1c:bbf with SMTP id x16-20020a170902ec9000b001545c1c0bbfmr6264118plg.56.1648129850780;
        Thu, 24 Mar 2022 06:50:50 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id z23-20020a056a001d9700b004fa8f24702csm3087327pfw.85.2022.03.24.06.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 06:50:50 -0700 (PDT)
Date:   Thu, 24 Mar 2022 06:50:48 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/6] ptp: Pass hwtstamp to
 ptp_convert_timestamp()
Message-ID: <20220324135048.GC27824@hoboy.vegasvil.org>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
 <20220322210722.6405-4-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322210722.6405-4-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 10:07:19PM +0100, Gerhard Engleder wrote:
> ptp_convert_timestamp() converts only the timestamp hwtstamp, which is
> a field of the argument with the type struct skb_shared_hwtstamps *. So
> a pointer to the hwtstamp field of this structure is sufficient.
> 
> Rework ptp_convert_timestamp() to use an argument of type ktime_t *.
> This allows to add additional timestamp manipulation stages before the
> call of ptp_convert_timestamp().
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
