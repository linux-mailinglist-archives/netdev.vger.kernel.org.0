Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC87467370E
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjASLiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjASLhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:37:42 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571E775A21;
        Thu, 19 Jan 2023 03:36:06 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id u19so4855384ejm.8;
        Thu, 19 Jan 2023 03:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cvYFLl9LiwvzqsWZZbX+Ppnx6x1WOa2RlZddWq2EK6I=;
        b=ZHnCCW4Gh7EIiUGOuqiOZtsxeVAjpJc76Jd4eEWuWb5D5U9PR6PA3PA9YG+s8lkW/5
         tFAYvhoOk7RGa8IqLwlCM+U8oprPiFDvjoEu+LFnmgF8+zua+0NR3AcVw5i517jvvl1w
         KmqKGl5RvsBjKr7VsNyc7BKBUxLJSV/L2Wzio9SA9X3jk0o/uNkHM5XE7yW4ZU4twIt0
         ldUYsVgi8ol+g038rOHrVaE7EWeP9xk/ybH1a/MWTLfhFfu3gShw2eCQObOJ+sM9KL8+
         Y+ZvKvzLt41u2c+ZQTAWfbQWJpfNJXbs1d/MzUFcxr2ImCUWAzJIEiQ7EAPTBVLlpdGX
         SPhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cvYFLl9LiwvzqsWZZbX+Ppnx6x1WOa2RlZddWq2EK6I=;
        b=K1nw+uDrZAtRJSpu1+ILqhFQetW8/OBa27RqPG7r4ZsRUYprwd6aCnLP7PvTum8tKt
         0asBdT6vcn+d60vVdzE5QwTGqJj1OhwURLF38LojAMG+C8KDaEmgPAGVoMbTq77plKtD
         qJZqWyyxsa6zZd0SeG6XrNbsudKR1XU1bUt6eY/vCeKl4tmhWIvy9L2FawWE3mp/ao5C
         Mja5kZRYsmTGZq2Qizp3ocAY0AC60VQl+iFskaINmq1H7ORNZS5AZj8ojalNMd8WG+ip
         l3lWe+szTGFkXn8tl1wSioKTITfdcF+RSuAPZtysteWP8t1KePwIz42SXTuCtpnPSvo/
         0vig==
X-Gm-Message-State: AFqh2kqCsr8+x7+Fy89pBzei6Wm11QEq35acn6b5gA/MXjusc+HUO34+
        O/4xHcIYOxEqgOZsuvwDmW2IQywJFkZGkw==
X-Google-Smtp-Source: AMrXdXt7L2rPF1Xw2fqGBl9xVE/dhQGwIpoQxryv7a2IrxLWoE4/PB8DRdMGhx6XwyYSWzWsFyd7NA==
X-Received: by 2002:a17:906:415:b0:7c1:2e19:ba3f with SMTP id d21-20020a170906041500b007c12e19ba3fmr24861529eja.57.1674128163601;
        Thu, 19 Jan 2023 03:36:03 -0800 (PST)
Received: from skbuf ([188.27.185.85])
        by smtp.gmail.com with ESMTPSA id 21-20020a170906319500b0086faa5b06d4sm6135694ejy.181.2023.01.19.03.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 03:36:03 -0800 (PST)
Date:   Thu, 19 Jan 2023 13:36:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh.Sankaranarayanan@microchip.com
Cc:     andrew@lunn.ch, davem@davemloft.net, pabeni@redhat.com,
        hkallweit1@gmail.com, Arun.Ramadoss@microchip.com,
        Woojung.Huh@microchip.com, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, f.fainelli@gmail.com, kuba@kernel.org,
        edumazet@google.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: microchip: lan937x: run phy
 initialization during each link update
Message-ID: <20230119113600.xfkkpmdz26og2hn3@skbuf>
References: <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
 <20230116222602.oswnt4ecoucpb2km@skbuf>
 <7d72bc330d0ce9e57cc862bec39388b7def8782a.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d72bc330d0ce9e57cc862bec39388b7def8782a.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 11:34:00AM +0000, Rakesh.Sankaranarayanan@microchip.com wrote:
> Thanks for pointing this out. Do you think submitting this patch in
> net-next is the right way?

Hmm, I guess you could submit it to 'net'.
