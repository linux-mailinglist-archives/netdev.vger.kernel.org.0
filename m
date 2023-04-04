Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A016D5F07
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbjDDLeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjDDLef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:34:35 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720912735;
        Tue,  4 Apr 2023 04:34:34 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id cn12so129296584edb.4;
        Tue, 04 Apr 2023 04:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680608073;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EiAbU3DoZ0xhdsd8tStndJGL2gzx7CIgMQ3cBHZLszc=;
        b=VgwwYrTZN55rM09eP/8k6dMXVRKGAnYR7ZJwdDlNIHk+N59QdH4oJv5fHDc0ShWWe1
         eylMUlrGeJoC5Mm5H/qxhpb7c7ibhfj2GLx6/cn8hDuhHTqqnBje61cMUJWs4VYiQhQx
         qFQHxG0r+AIQler7IOZBnoQ/mugP+V8HSPYSHdQD+FE1k4z7nE0PHLN+9Hm3ljSiV/1m
         CbfZZIbD9JcFOb5Beb8vUQxkquAErCmUzxUYQ2jAS9oJ3NsCVy2KG5xLYVk77bx3Ee/S
         lmz4O7JV21zZHCXDrXw+BVuMMcQDKjo6+PPGe8l3j0BWf0OrLTmh6HJ8P1rkvjieHXWt
         FGNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680608073;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EiAbU3DoZ0xhdsd8tStndJGL2gzx7CIgMQ3cBHZLszc=;
        b=iV4A/n0O09V2WoH5WDigzrnicuZL412kFjxCGg2BWmyaEcnnRhzyikkMyGjIyq6mxG
         IrT2POJGNpPTz7qh3dNCmrkxpb+1l87KDqRBLpJmZjBTWVZTZYAHQNPLm7rAzJLV2oHG
         fWmi48wyuOd1LMGreYXZ98C0AH+uyHT3YYZ3pEjKTITvEgVkHqTGLXGxq0MMZ5Nxxv/l
         upxPWwo79UO2zmMsuMIPBh/2BOjT0wziewhpprbmLx/UlGoxTbMu8K2grmcHw9XhjeHi
         AivvhVXATdOB2DJU0/oG8raBHp2IJAi7TXntKI3MbxUpWTMdM8whQB98sb0f3hrj+qSf
         /m8A==
X-Gm-Message-State: AAQBX9fG4eN5ZBjRb4Q4PlIMWA+CksdykwDdKztHd2LVW5IMNn2hRcjS
        1lUaWc8JS7CwtH79IVgMVg4=
X-Google-Smtp-Source: AKy350ZvatmHKJXsNXLQwMjhyml3O/zSIDfC/chsOuJRvZPgavuQHw4G772r7Mu4WwTGpenE5pE1+A==
X-Received: by 2002:a17:906:5390:b0:944:308f:b978 with SMTP id g16-20020a170906539000b00944308fb978mr2014279ejo.11.1680608072945;
        Tue, 04 Apr 2023 04:34:32 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id bt23-20020a170906b15700b009477a173744sm5831573ejb.38.2023.04.04.04.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 04:34:32 -0700 (PDT)
Date:   Tue, 4 Apr 2023 14:34:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 3/7] net: dsa: microchip: ksz8: Make
 ksz8_r_sta_mac_table() static
Message-ID: <20230404113430.jxepbl7nwrqlimdp@skbuf>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-4-o.rempel@pengutronix.de>
 <20230404101842.1382986-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404101842.1382986-4-o.rempel@pengutronix.de>
 <20230404101842.1382986-4-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:18:38PM +0200, Oleksij Rempel wrote:
> As ksz8_r_sta_mac_table() is only used within ksz8795.c, there is no need
> to export it. Make the function static for better encapsulation.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
