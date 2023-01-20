Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F49675063
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjATJNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjATJNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:13:37 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628ED93706;
        Fri, 20 Jan 2023 01:13:10 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id bg13-20020a05600c3c8d00b003d9712b29d2so5375186wmb.2;
        Fri, 20 Jan 2023 01:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ux8y6Cx3Fu1EDV86Is7psjeM9rNqa+KOawGSAK6XGIk=;
        b=JUgOOzKNnW0nTnbNzRK1+tRYnthmcPUqJTN+A6ZkCo+/vW3HP/to4oXcN9oRUgUPuY
         0aE27/2P042xOIud6eaSEm2xttT0WWA6ZGzhHP8fe/3ka3kGNjvFWwduztFn4bPog1VJ
         MbJo00GcJ4R9qQbSXvZQoRyUPSfdAKla7HSCjTa7YNEF5FbsDGhC40jHcZ/Tt97Z4QFI
         8Cb9lOI7oyDHhMa9Wi71iihLbRljnKGcTFP46jTJpYVW3NV+dr5t/pIJAb9vKBezfU4b
         7jeQfJQ/1pbTsNH/WipPasrCfHSm+ivPa3lknfnKn/03vXV5MUQwm1w65+s4L9Eirfmx
         LcAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ux8y6Cx3Fu1EDV86Is7psjeM9rNqa+KOawGSAK6XGIk=;
        b=265E1Jt6AOBf3IGD5kUgdC2eBxRD0oXkbSbh+qoBqm6PuWQ+UQnsTJz7MvPEBiu4MP
         9Vcdg4zVM6lLlvLRH0rGps2FsY6ddLUIVE8Ae3vrBwONgbwX4Ul5LdYgIx5Y40TsSZYM
         UfUorksSYQj2NnPj+u/UlOMe0BG1r5VFX/zcGbwF7VATdI3BgyJnR9quSC5VnQIdfF0B
         L/G2tb/ax8krRJLOAn4ebkstUF2VIrCVANPEwDNkKQy3VtYlrzYoKkzWaqIdwh7TDzCA
         X89y+IMo/Nsotq1RLiJTDZAeDPHN5j0cr/+X6AMwE8i5zOUd/RBPew1J3ni61C6vb5k1
         WQqA==
X-Gm-Message-State: AFqh2kpavgz/7JfVx5L8N/bWF+nQJ3LAYPOindWfFzbdePGgwmzAlSUi
        KleAeitM++6EF75qBdovico=
X-Google-Smtp-Source: AMrXdXujUNuBhbykArz4bplt23suFeP7EOY/IXTXm6XfPcIkfmHck7sImTIaeoiTw84iE4TZKAXfMw==
X-Received: by 2002:a05:600c:4256:b0:3da:2a78:d7a3 with SMTP id r22-20020a05600c425600b003da2a78d7a3mr12824255wmm.33.1674205985529;
        Fri, 20 Jan 2023 01:13:05 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id m2-20020a05600c4f4200b003db0ad636d1sm1789231wmq.28.2023.01.20.01.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 01:13:05 -0800 (PST)
Date:   Fri, 20 Jan 2023 12:13:02 +0300
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
Subject: Re: [PATCH net-next 4/8] net: microchip: sparx5: Add TC support for
 IS0 VCAP
Message-ID: <Y8pbHvJpvuIuCXws@kadam>
References: <20230120090831.20032-1-steen.hegelund@microchip.com>
 <20230120090831.20032-5-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120090831.20032-5-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 10:08:27AM +0100, Steen Hegelund wrote:
> -/* Add a rule counter action - only IS2 is considered for now */
> +/* Add a rule counter action */
>  static int sparx5_tc_add_rule_counter(struct vcap_admin *admin,
>  				      struct vcap_rule *vrule)
>  {
> -	int err;
> +	int err = 0;

Don't initialize.

>  
> -	err = vcap_rule_mod_action_u32(vrule, VCAP_AF_CNT_ID, vrule->id);
> -	if (err)
> -		return err;
> +	if (admin->vtype == VCAP_TYPE_IS2) {
> +		err = vcap_rule_mod_action_u32(vrule, VCAP_AF_CNT_ID,
> +					       vrule->id);
> +		if (err)
> +			return err;
> +		vcap_rule_set_counter_id(vrule, vrule->id);
> +	}
>  
> -	vcap_rule_set_counter_id(vrule, vrule->id);
>  	return err;

return 0;

>  }

regards,
dan carpenter
