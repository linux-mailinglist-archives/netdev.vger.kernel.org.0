Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F876D54DD
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 00:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbjDCWs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 18:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjDCWs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 18:48:56 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F003ABA
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 15:48:55 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r11so123410932edd.5
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 15:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680562134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ulxi5xQ0uFHtLW2IE+qPMXhHnliF/JKsUM6isaocGmc=;
        b=W/ekfu0BWbYV5dHrz5JvQr6eXs9zL1SNZL8Gnq7pH+9wYcpU7ojoyasvCme72nRvMt
         JOe4IeALs43aEU8hVHt05U9Y+P81wIJh8MlFgyoJxA9XgXf+NOmplnEGjsJE9m75DZSa
         1LfAtf4v9ujz//tU6zqB+YfhhvKIN5/HOHvx8y/8y9BQK6BsixsrnesmxGDf+W9BoSMl
         21YOpAGq1N2L/hKZ01YLy0A16m89PwdF5KQ/yLEjjcNqoxuTDATs0/jUTAP6nsH5mnB1
         x8zFRBGYGAl7zo8e7y0dMawBukZiUYy0UAnNkHGiacT58YAQ9c/ZPY0xrK/HR/z9v63C
         YJRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680562134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ulxi5xQ0uFHtLW2IE+qPMXhHnliF/JKsUM6isaocGmc=;
        b=kNLzn7As8+eaMH2LAK3kwfz/CJxlT+zMZCjHcGO+3ouOEDcLR+p0XzI4JIJfqTwaDt
         T5LAHaodHkhBVUxnQ3fsi3TBi2wxcitpHqVXguVPCzd9vhjWOipxBpHev+i2SA1obQFp
         rUMtXPFFReskmljNF/YwZ3PGTT9gzklBxUCTq4vxzH2sRbKNMLXPxW4ZBECoZcNNCwXq
         jq8tkg5D357MxSin8LJKJzqMjDLXVwZ+2fWvNCTadJHBO0vNq/RRw3v9l369k4UNTx5q
         0o0yKZxned/j66w/VRrO144EHYonUpi9D7Rejhi6oJ/3OvQOjNxr0oFGe19WLvJdKKac
         7A9A==
X-Gm-Message-State: AAQBX9eVWVkK9Hw1WjHLNrkjW1vgY8iTJLcaXsPFzdEiUcoRxjfJIxI4
        DgrZ2rHlrN415gAW0yq/VBY=
X-Google-Smtp-Source: AKy350ZhvWAvHS8ilDCcR7oUXnEx1EIJ3+szlGQLgbbeOKZ7Ykm/p5+X5dgacFnIHfIb1p2bPfiCRQ==
X-Received: by 2002:a17:906:224e:b0:92f:39d9:1e50 with SMTP id 14-20020a170906224e00b0092f39d91e50mr243544ejr.3.1680562134340;
        Mon, 03 Apr 2023 15:48:54 -0700 (PDT)
Received: from localhost (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id tq24-20020a170907c51800b00947abb70c93sm4777885ejc.112.2023.04.03.15.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 15:48:53 -0700 (PDT)
Date:   Tue, 4 Apr 2023 00:48:51 +0200
From:   Richard Cochran <richardcochran@gmail.com>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next RFC v2] Add NDOs for hardware timestamp get/set
Message-ID: <ZCtX06pztpWL1jwO@localhost>
References: <20230402142435.47105-1-glipus@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230402142435.47105-1-glipus@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please put me onto CC for this work.

Thanks,
Richard
