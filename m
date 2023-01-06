Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFBB65FD36
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 09:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbjAFI6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 03:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbjAFI5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 03:57:19 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278B7D71;
        Fri,  6 Jan 2023 00:56:11 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id bn26so700342wrb.0;
        Fri, 06 Jan 2023 00:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6eTpEaZS3gI5KkJOL7rAYuEVIpZC2a1r1N5nUQx2/48=;
        b=pmGa0wZ23WgLNDg+K81xV9MA5BkK965hsvbic0PPUJ+w8TipXc1bn1ziXM39x2tqlf
         7wr2F9nO1mcojmWOjEIriLKX5ebxT0Hl87lzP2rHvcbied/EFwXFpTv8IGyuUFzZjhuq
         YQ9ysdHHARISpfdmc/+UrwyMxuC6ByHD4SbDIXlE6bZLLxUunZ3Ch/aZa9W6gle39v4q
         hq22SmMYkiv5oiir5XuZRiAzLoa4he8dRDOLnkO75pes5k9R+3cMhs6+EmZTERiwh+Nb
         nn/39VAlvIBFgGQR6jDiWjOHxM59xuNuyPxfVQ72Z0JwVjRd41quUW7BU1THrSRYXf6T
         F+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6eTpEaZS3gI5KkJOL7rAYuEVIpZC2a1r1N5nUQx2/48=;
        b=dnySSqeCeK2W/gmVinCasYCHrpAOAHytH55G4yzskR7dsLP0F5XbAHKn40gS+zVooU
         eKFu8XCETw3YC825CT1Pjf7AdhrDJ6NJxO3FoYc0bCl2m5yYvkpSQHaq6jShHtZsc04J
         qLF14Eqjkb/nvx/tUyQBUEP1eEL02ga4820/MNGLju10BCQePloQUI1svYvwKGbByVXy
         pdCafJFgCz6hXy/dDqCYU+KdOZxSrCNYsLv2QJ/69t6nhoGACIXyvVb+ooLPhv9agVnw
         jg3/xt9IpWquynlepELHkylQ1o3SE4K4PIRkmwrTfpHRb8kZbGY8jOEVKAw7sK4oYR6q
         UoYA==
X-Gm-Message-State: AFqh2kpXcGqgn2QNZ+Ch/wksD5fXzuOu15htTVVjbi9NGda8k/mlwBOC
        pH+435YJLdffZk8HltRTnGQ=
X-Google-Smtp-Source: AMrXdXuSCe/xgCkPs3CvwZY23GDRjA5+h4O/DP7gzLHP1bhKPRqDnutWxNWdk3hMlQ1Ut6NyW/Kptg==
X-Received: by 2002:a5d:4143:0:b0:290:3629:a824 with SMTP id c3-20020a5d4143000000b002903629a824mr18181109wrq.40.1672995370092;
        Fri, 06 Jan 2023 00:56:10 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id m8-20020a5d6a08000000b002a1ae285bfasm535407wru.77.2023.01.06.00.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 00:56:09 -0800 (PST)
Date:   Fri, 6 Jan 2023 11:56:00 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next v2 0/8] Add support for two classes of VCAP rules
Message-ID: <Y7fiIPM2GCqE2Upw@kadam>
References: <20230106085317.1720282-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106085317.1720282-1-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 09:53:09AM +0100, Steen Hegelund wrote:
> Version History:
> ================
> v2      Adding a missing goto exit in vcap_add_rule (Dan Carpenter).

Thanks!

regards,
dan carpenter

