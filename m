Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD396DFBF8
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 18:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjDLQ4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 12:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjDLQ4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 12:56:37 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FF54EDB
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:56:09 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-51b3d54b1f4so9806a12.0
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681318565; x=1683910565;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RxmGEIRp3vJG1MrHNaAJSYWeXZN5RgHqipP6IlH9jGE=;
        b=aJaCKBdo9piqbCJue6E/qNO4GviJmytBAuCAOyqdu3ZHfsCxH2HaUQ6N+1hbNa7tjc
         RHIwEsw6rO+C1xArp98eS9V6xCDl7n61UGQNygk4RxqAcI/AVWXUaugeO6fiqfVgV5tp
         7G3kxE3ZweCtAkVRpQnUVfp6wTeUXZaGDOYS5llSvzSxSrYz1Ein2lYk9gGAPWHujcaI
         cK7XS++Ud0tGRxH6ztSBMVT4rd3etOug55unRZpQnoegugQXEBtJTgNGzRJ5h6mcOUu6
         jjJvaZQJIkK0QwB1YzTmePo28jVXrTn36YhUN6OOAO/88JQLCHjHWzv/bdygHjGYHeIH
         5GqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681318565; x=1683910565;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RxmGEIRp3vJG1MrHNaAJSYWeXZN5RgHqipP6IlH9jGE=;
        b=EqA1o1TQiyl39J0NrHir19EiZpz492bUJjFndP7xHJorkRBUPvv5USPOP358FFYgXW
         LHLpHUpU+t2YUeF/5wdmTTf9WlOQ39isSVCAANnG9X91hEh4sHkdUtJbMcNVMBFy4COf
         iZOgQ4yZnHYWS0m1/1MwMd/o7dGhw9hqYUJnGGJj2fXuX42LY09knIAXGJOQU2oe+YCW
         Hk2zvB0BDlkKS3CLnZ6Vh10xajrrOnYgyByPbpDeoIs5VTKI4d26KIPoqBOeDSWpMV5s
         wJeR1Lywud8mWXCV1OKAt9lu90t4wrTaTqzhZ1J5LLERzqmGUb7GYUT0/b9LW15Ec/VB
         ihGw==
X-Gm-Message-State: AAQBX9di963auxr1U9Rhtmvrkn1IP+JJRDC/BB1VhOeFuwljeKXnyH72
        DMyNOUwfak2J64ysyC8CyBs=
X-Google-Smtp-Source: AKy350Z4Sy2uQN6U8tccNZh2pa0dKXDN+OGzBq5e6kLvAAZlepDEAVPZnEd2cO2AMRW2oPFLlZTIow==
X-Received: by 2002:a17:90a:52:b0:23d:1bef:8594 with SMTP id 18-20020a17090a005200b0023d1bef8594mr2578294pjb.1.1681318565416;
        Wed, 12 Apr 2023 09:56:05 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id o73-20020a17090a0a4f00b0024677263e36sm1697727pjo.43.2023.04.12.09.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 09:56:04 -0700 (PDT)
Date:   Wed, 12 Apr 2023 09:56:02 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        kuba@kernel.org, glipus@gmail.com, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 1/5] net: ethtool: Refactor identical
 get_ts_info implementations.
Message-ID: <ZDbiohDFsGqK6aWS@hoboy.vegasvil.org>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-2-kory.maincent@bootlin.com>
 <20230406173308.401924-2-kory.maincent@bootlin.com>
 <20230412131636.qh2mwyoaujrgagp5@skbuf>
 <20230412154958.287be686@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230412154958.287be686@kmaincent-XPS-13-7390>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 03:49:58PM +0200, Köry Maincent wrote:
> mmh don't know. Richards it comes from your code, any joke here?

No, just a typo.

Thanks,
Richard
