Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5FF62DCE5
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbiKQNfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbiKQNfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:35:45 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28B97341C;
        Thu, 17 Nov 2022 05:35:43 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id t25-20020a1c7719000000b003cfa34ea516so4463216wmi.1;
        Thu, 17 Nov 2022 05:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x6POjAMUpDXmaPvarwrQ8Ki3/k/Z8hYQ/JKNUyT/xVc=;
        b=hjkI/d6+kiYWoGMRIBaHuKzkPhiTq6Tk12jhhK6Q1Pg3N0Ooestveko6ciNfM/S/fL
         iX+Q+Qg3g6Pp5TgITBvbk7Bp8lP+lcjqutJFmEVsh1PUPJC2GV8elDFNbOQy/f7Vbind
         nOwlEtsLEa8q7p6zS92XMzInKL8a49M+ik4u6B43oNSYb8jVHOchBJg7AmqeEuqYaUyP
         upXDoobYXrps2kbm6q8UQWnJem+oM+zVKde1vADU18na89/2lkLO/VTAVeevSVMsBKaO
         QfmALTkkuX0aW24bOJXDMJlhUcW1JqGezYIjw7CNawkSjnMYkTLP1C5azLqg0EeDh/wD
         rDeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6POjAMUpDXmaPvarwrQ8Ki3/k/Z8hYQ/JKNUyT/xVc=;
        b=DVuWW2Oft03dJCqGRPHfNTZKPs+s4Vdj8PRAInbw/j4F/W3L7on+jtfQO/9+TYilaX
         CAFF25N3rl19SWhDPXbU8Rs95huOThz80qfTvPa6DyEx22AZo2TFnS9pv6xpntyh/uGT
         jC9JMwt5eBrrw0dCoCIqGfLaxRPqZ41K6OW4Dza17iOjBHesZ+wVZiYyfazde01gVg1u
         owb5ic5ev43nmz4qwKLhZNCzwTb0aphOyNu4QIgRvyvH+1xNFIGQ83rrjUWp/CnEDSVh
         SJP7GdQ9x1kZbvkW9kDjMyu2rIm+BCK371HP77lrZCt6eC+EpVkjLrnNecrsvMNHCdFc
         tr2w==
X-Gm-Message-State: ANoB5pmY62+gOUkaVYoVORIGQ7hkLX2zHgswAIRwRDWwXH9FPtyztJX4
        mC8rNlX28eDjR2Dbvztli8I=
X-Google-Smtp-Source: AA0mqf6g6+PH1eqWG2AWQPhNn4sehJNK1bk9I0WYkoZR2Hm4c1iiGh5hhb+D/+++Ag2LbhBS2+H+ng==
X-Received: by 2002:a7b:ca45:0:b0:3c4:bda1:7c57 with SMTP id m5-20020a7bca45000000b003c4bda17c57mr5381035wml.6.1668692141707;
        Thu, 17 Nov 2022 05:35:41 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id bg28-20020a05600c3c9c00b003cfaae07f68sm6394714wmb.17.2022.11.17.05.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 05:35:40 -0800 (PST)
Date:   Thu, 17 Nov 2022 16:35:37 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     David Howells <dhowells@redhat.com>
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] rxrpc: uninitialized variable in
 rxrpc_send_ack_packet()
Message-ID: <Y3Y4qa8xvRvsJBF0@kadam>
References: <Y3YOUQM/ldDe/sgC@kadam>
 <Y3XmQsOFwTHUBSLU@kili>
 <3475095.1668678264@warthog.procyon.org.uk>
 <3708248.1668686372@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3708248.1668686372@warthog.procyon.org.uk>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 11:59:32AM +0000, David Howells wrote:
> Dan Carpenter <error27@gmail.com> wrote:
> 
> > We disabled GCC's check for uninitialized variables.  It could be that
> > you have the .config to automatically zero out stack variables.
> > 
> > CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y
> > CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_BARE=y
> > CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y
> 
> Ah.  Is there a way to reenable that?

make W=2 will do it, but W=2 sucks...

regards,
dan carpenter

