Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E5D624456
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiKJObN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiKJObM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:31:12 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672C01128;
        Thu, 10 Nov 2022 06:31:11 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id bs21so2522063wrb.4;
        Thu, 10 Nov 2022 06:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ey1AQpHQJmLwWlHR7WvCo+Mh7OBWJhTN7kBM9O932Lk=;
        b=lKVxtGAF6KgZ9znDKbiDgn+29vfeR/baAnBRLSwXGwS8lrJK5dFBom2qqIAcD4iZ07
         4gWDWd/O2+CmLLlMR1NzXypB1WL7giM2k5jlsCTabTOmgSYtP8zxYBU0WXQ2K0/awMa9
         iMW0blvOuwz1ugGR50/KPaMg4xpD+JWT7EMVpW5Vs/qQgtSfdxiWZwtgekjI2rFlSOBV
         Yl6Emh7wKEaacMNqWVQ1CLAzHGwFoPh0euQzAO4EIM2AhyzpSIx4tSosmvFp6nMduRDm
         oZR2+4KR3iRRhaMUDANYewdq2JZMXzAZ4XwAqBdCOV56Z53mJRdhICxK1HIuUHFXwtX4
         87Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ey1AQpHQJmLwWlHR7WvCo+Mh7OBWJhTN7kBM9O932Lk=;
        b=zIpwmIoEahfdGaXNo+EnCjnNhvt/IFxiG/71VbMg57O7n4+TQIuJIEBxGPtUp1smTG
         IVz8TXAl+I25Y790nLFr5DTaWaWr2UkQKbteMKKwvcVkyRSsFjUfNl5xcvGM25f7ftiU
         v0SZh9JceX7rEINsI+UBTt93kbb7I/6EccUcuU73W15KB9wiBSpYBmdh05xcOrhXYQmV
         2v6VsmCunxdCcKjx9foiWR0d+hC1MKJAeJraHI4ut1fzDPEQKfY0MdqW0JWUJ41OuVYI
         KRLztxQJKwoj1DegkIC0fhaMlYxZtKEDZqtpPdji+gQVorjYzJIs++1mYYi8mKKWlDW+
         3cnQ==
X-Gm-Message-State: ACrzQf1vBoLg74eoUn9H4bOgxxJaZmP2M+oL0ejryglQvAzbqQDqhKMg
        E9gAGxItUGpp8B1lPkC2Kubo/eATppyxsg==
X-Google-Smtp-Source: AMsMyM7wiH890UFM7ywsgSihfawl87lkuRK49fnsLmY/LuBzeAlWQzUPXBhrbPCLkwy03Rd1GBfUwQ==
X-Received: by 2002:a5d:5d87:0:b0:22a:bbc5:5afe with SMTP id ci7-20020a5d5d87000000b0022abbc55afemr41324229wrb.235.1668090669749;
        Thu, 10 Nov 2022 06:31:09 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id h17-20020adff191000000b00236488f62d6sm15801731wro.79.2022.11.10.06.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 06:31:09 -0800 (PST)
Date:   Thu, 10 Nov 2022 16:31:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 01/12] net: ethernet: mtk_eth_soc: account
 for vlan in rx header length
Message-ID: <20221110143107.335esdtwbfqy7ktu@skbuf>
References: <20221109163426.76164-1-nbd@nbd.name>
 <20221109163426.76164-2-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109163426.76164-2-nbd@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 05:34:15PM +0100, Felix Fietkau wrote:
> The network stack assumes that devices can handle an extra VLAN tag without
> increasing the MTU
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
