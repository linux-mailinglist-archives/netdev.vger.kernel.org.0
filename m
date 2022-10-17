Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D49601696
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 20:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiJQSrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 14:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiJQSq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 14:46:59 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0FA75390;
        Mon, 17 Oct 2022 11:46:54 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id a13so17415671edj.0;
        Mon, 17 Oct 2022 11:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xOnduGdWwNX1YfeZsOAvcXCZLPvcfJ2PqKkkX8Fx7O4=;
        b=NMkdJwU2X/H+STTyDxMpUL1FQFYwoN+XheRebuwN3COa2JW/UEuI5jOS1BIwEgypnV
         ciEz60dWdsSLJOO0r8DALjo880+eW6td2yueBqrIGJs1qm5EuKV3/a5/jyPSRcGjAVYP
         sJREphuL3EwNzUuyoZtGXAtGZA6SQ0ULbvW1cCEOQ+PsCOLRw/P8VINZGhynBJuY17qW
         oL82A35ian9mlu6o+3zYMsTh5o/v1wd+x2JM+UKyMPCEVOAChjL4AQVMcUOy/Mn8WGiu
         Mau+v6d0TRGTSikAzuzX/8bxKqcn+NNIjjGsN4KtwpP1/PNjdGoSB2jtPN1mqzWvVmyO
         OHWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xOnduGdWwNX1YfeZsOAvcXCZLPvcfJ2PqKkkX8Fx7O4=;
        b=LqXW7PtqWVzVYh4OaGwkrj/ojSZXZbrbs3pq2KJsl39pZvcZZMB2FwuKYyQzkLK00+
         /uyfxAtS0n8DOGkapZUzfh3NjXlumErxkWMPo4ngH0jRzex2Oy8b4JXVSk5/1ASAKzDB
         twwJJ1HYGLVm9wuabhJ1tulAbKlbQ739/oinhHmuv+NzmDERRvHXBnNSxlrgpil7nGpW
         x7bzTzoTMcTn2muDRWZe1i+fRejE3naHNwsOX8gPMZ+jo1ze6zMcSMDze+6GIpwSLsiy
         YGW6noj1x0QDpSrpaXOOYFar2PIQtL4orK1M+aNPU0L2uBVbXhLO5OALQIjZIbOssMLI
         fz0A==
X-Gm-Message-State: ACrzQf0JmgYmNuHKpZM4usOvQK0CJgWVaUX3jrwqD1L3kc4MkQWATLKp
        Q1nMtmODwSg6IS/sXw9vvWY=
X-Google-Smtp-Source: AMsMyM5ZAyJ5V+XIL0BwajqkqHOZh1Zrq/87LpgSUyRWGilqq4El/ypNBkUxveL7Ze4gbsLPs7vn4g==
X-Received: by 2002:a05:6402:1394:b0:456:97cd:e9d4 with SMTP id b20-20020a056402139400b0045697cde9d4mr12055900edv.174.1666032412435;
        Mon, 17 Oct 2022 11:46:52 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id kv2-20020a17090778c200b0077e6be40e4asm6567982ejc.175.2022.10.17.11.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 11:46:51 -0700 (PDT)
Date:   Mon, 17 Oct 2022 21:46:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com
Subject: Re: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support
 for LAN937x switch
Message-ID: <20221017184649.meh7snyhvuepan25@skbuf>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014152857.32645-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 08:58:51PM +0530, Arun Ramadoss wrote:
> The LAN937x switch has capable for supporting IEEE 1588 PTP protocol. This
> patch series add gPTP profile support and tested using the ptp4l application.
> LAN937x has the same PTP register set similar to KSZ9563, hence the
> implementation has been made common for the ksz switches. But the testing is
> done only for lan937x switch.

Unrelated to the proposed implementation. What user space stack do you
use for gPTP bridging?
