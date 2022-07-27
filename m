Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768EB582901
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbiG0Ovb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbiG0OvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:51:25 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A87E4330B;
        Wed, 27 Jul 2022 07:51:24 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id z23so31661241eju.8;
        Wed, 27 Jul 2022 07:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BcjOvUvgWV3BAQ3E9l0s9PTFaWNeusUy+QCOuPABOmE=;
        b=aIlAHoCIkpUuoFHze+Z/HfYl16wa//iWgR50y4BIOQG12KxZNheuNuPx4QaMsPcHqm
         mnZTKT30y4hERKheVcKgOWuc9ILKvw4bvMHYTknr/uVZW9ct0Ca6BFmzjcfx3DyePj7n
         HAYQ76lfQFgdfuGwema7jPQu6LQk2DhfWdQ+oPd0fihedkj3mLKCQblU5z98ZVBTHIge
         fh3OjF7BjuZxDumYWnhc6u6sn5U4IOAsTsRUuxARtB96zK69iLbRdwMg2dskRxnAox0s
         zLu1DF5KshQ0UR0ZaWhIoIktCXouEHktxJT3w+9LNU1l51A511dTlxH59oI4qZkxWCf1
         P9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BcjOvUvgWV3BAQ3E9l0s9PTFaWNeusUy+QCOuPABOmE=;
        b=H8CP0P7uX3xoDSnLDDnBQ+6g4o+tt6oznWODDswGy2UXsKxWzBMDH0E5gT5rIBH6ct
         2FsC56XejELVFUp/moitUYtkbLllUwUxj2EPouYK0OzvBJN0K3/UWN1CNFjxiNf9+yiO
         nPylJLcZ5cJ6ChWaRjuMgqhcmZlpRIC3U4t3krhoMAAfPVUSgmqkj1izNxtVlS+L357I
         7nelT7NDKOtjRHbELu85US9jgJ92PQOsjaCfltvAllMj+SZQ1gdVMXjNPUCkLGQ6cJjl
         dLCIAFfPobZXPz3fbmdJnq1m4c5QFrL3HYH/Ur4KDy3mBXLxPpmOsXwMvobtEAt1jcRt
         NtJQ==
X-Gm-Message-State: AJIora8h7igH6mkcL5He9rgfFZXV9eDbj38s7jZEqdJE1CJ3pNgb+ljL
        SVnkoqA7h4QphF7GqfDFIJ8=
X-Google-Smtp-Source: AGRyM1s+7nwMGXZmSD9whtEJSdR5QkrRdiRbcb5I4XYYYpgtg2Y/shyvcZjjk5AcViB/yqWvzIj8OQ==
X-Received: by 2002:a17:907:7f1c:b0:72b:6e63:1798 with SMTP id qf28-20020a1709077f1c00b0072b6e631798mr17622362ejc.538.1658933482763;
        Wed, 27 Jul 2022 07:51:22 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id gr19-20020a170906e2d300b0072b592ee073sm7808216ejb.147.2022.07.27.07.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 07:51:22 -0700 (PDT)
Date:   Wed, 27 Jul 2022 17:51:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v5 06/14] net: dsa: qca8k: move mib init
 function to common code
Message-ID: <20220727145119.cruovluea4go7yl7@skbuf>
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-7-ansuelsmth@gmail.com>
 <20220727113523.19742-7-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727113523.19742-7-ansuelsmth@gmail.com>
 <20220727113523.19742-7-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 01:35:15PM +0200, Christian Marangi wrote:
> The same mib function is used by drivers based on qca8k family switch.
> Move it to common code to make it accessible also by other drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
