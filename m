Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF57766A616
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 23:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjAMWjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 17:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjAMWjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 17:39:06 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D10F777C3;
        Fri, 13 Jan 2023 14:39:06 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d3so24828220plr.10;
        Fri, 13 Jan 2023 14:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oDx+VYFUmsoVHgqYkO1ZDEtd/XtsUvEQW/y33JnOvQ8=;
        b=c2wLEwSAA3bwQpw2bBpb9A1WhokV7foWTkDViUeXca5Qjwlj6W218glYGwbvK/iVx+
         tDEJtwjR1F970w+NlKFLRPArE+PHlKg7KSWYnduvLXoDA1BFQCGUEyky0Jl1cCGcoIds
         tSLQQg7D3b2lYZ7LrRfzy/kHy4P4ItdvVGSC0q6PDaw4tZWtWkL5xsg/jgCivz3lMxcb
         bgJEbqS2Hh7JF1ja3FsGnwg7NvvRtIqcq44kDeOmmxuR80I/NNdjIKeWaCr7dw0Cygoo
         FQvDb4zYvB3f9qrkcSY43+E7YoJdqwzDxxD4jMtvRDUuxL9rLiqzWrwUhVId5uNky4+d
         sAXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oDx+VYFUmsoVHgqYkO1ZDEtd/XtsUvEQW/y33JnOvQ8=;
        b=qCvt2QOKa1RJkggyWGLo37PvCYUaewmpsVCof7TLIwA1dw5w8uQN49RKZzlNqKpW6z
         AiGuqGRi0TGMOMQcCxb3s8HmWq1IGJY3XK+ZdaUAf1BEP7j3B2baXnqz2TCvgHVe20tu
         yExYPO5TF9KzZ0Av87Ndg35d9JOSxoYlcwErl8/JH1M7fSWUEkQYADYT4tGA7Oy+JTTz
         OlvMu0eovz6NVlaDaeYe3/wo3n7qN/i/7ps2XUvJ6NloqHOYwnLBt01AdMemweYA24+E
         PTHN2D8vaeRKj3nnIRvDcITiDcmXKke5kJ/r6XHB6i8SLySh5Ca46PKtzjOGxWFghDRU
         BZhg==
X-Gm-Message-State: AFqh2koLhA4+EBsGtVGgTyYypl8zr89BZmhADa8emhNIywcEzfAg4q/p
        ySYITXFuKDduvUuOYPsj3qA=
X-Google-Smtp-Source: AMrXdXsvULaAB1fIoJWVNZyiDcsbAGduBTEV8HboPy/49RosxXWKWUoFJe9F/kVKv+fxOiM9O8SJsQ==
X-Received: by 2002:a05:6a21:599:b0:b5:b45a:656d with SMTP id lw25-20020a056a21059900b000b5b45a656dmr23234236pzb.18.1673649545539;
        Fri, 13 Jan 2023 14:39:05 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id s6-20020a63dc06000000b0043c732e1536sm12182891pgg.45.2023.01.13.14.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 14:39:05 -0800 (PST)
Message-ID: <df5db53729c9a626a898edfc990337e86afc995f.camel@gmail.com>
Subject: Re: [PATCH net] net: lan966x: add missing fwnode_handle_put() for
 ports node
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     =?ISO-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 13 Jan 2023 14:39:04 -0800
In-Reply-To: <20230112161311.495124-1-clement.leger@bootlin.com>
References: <20230112161311.495124-1-clement.leger@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-01-12 at 17:13 +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> Since the "ethernet-ports" node is retrieved using
> device_get_named_child_node(), it should be release after using it. Add
> missing fwnode_handle_put() and move the code that retrieved the node
> from device-tree to avoid complicated handling in case of error.
>=20
> Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>


You should probably add a fixes tag to this:
Fixes: db8bcaad5393 ("net: lan966x: add the basic lan966x driver")

Other than that the patch itself looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
