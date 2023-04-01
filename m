Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28E56D30DD
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 14:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjDAMxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 08:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjDAMxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 08:53:39 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E49FCD
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 05:53:38 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id cn12so100192371edb.4
        for <netdev@vger.kernel.org>; Sat, 01 Apr 2023 05:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1680353617;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IsXudeJf7ex/KMkd9XKZrKSgXi5k8V6Ttiz3EATGpHg=;
        b=aEyF2EFqPsdk0bwXMo5zmj7q77sIpNvMQ0J1s5h/QDOyoI7rPgOkDNb4mSO3rxJKhO
         R1nwP1io/pqkC4+gLFnMxczK7arE13+14mgfLVoLH9AEZQLwBeFkDZtk7XLWdtlrwvFz
         2w39nql083wFUEvKtzSjMTLwLj761DinO2OLxcyp28m2+UzozNw5ZOMgSjJVBsGxmdx2
         nnTiget7yOpQ3qydH/FzPx9nLPtDLnM7SGm+nyuYw4d+ht+8D1HJpRTZeTT2VSqvVFAO
         RkqOmX2eZXIncAVKWCk/CLb4k4Y/DFqCr0TEd4wBfZcKZG9UT6UNnTx4VCTnSic86xn1
         27+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680353617;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsXudeJf7ex/KMkd9XKZrKSgXi5k8V6Ttiz3EATGpHg=;
        b=0nJ0kogCazJLZD0deXtHYyZSbeXfWqYNr+yFaMjBtyRTpQ+Ln6D7QQ0pRAfvuEZ0zP
         QyD7CHqMUrf8ONAsGxLDbReEOs+Udx7xCp1EiMuFqitJeesozMdITVbNRjew3Ml0/pG3
         6q0vMt+7ZAlrD5OyHxjq7LkiPhmqPZdJkqH2FZZ9b/s9SpAcPm+dfSiRCcjan8nJzbII
         Z7cJW1yZf/RjXeVp2lWohSdMhW4oUsOfjtpme941hj17kA2f0HkfbAApTIiyHz+geMEx
         tskyvaZUQX3Q33x+m5W5h7BvTx8ZBhnLrKoxzlW3W7KCtGh+vxB5q/w5SjA955mcAqqd
         5ekg==
X-Gm-Message-State: AAQBX9eunMrPvP7N5VoifAFwrJASHWIGUCSc8+o0uShGmeEIgRHuJOtn
        kfZOJlyqpc4bzkta5/8rRdCMjQ==
X-Google-Smtp-Source: AKy350av/v61Im2E/iRFPy8cHyBemO9SfGylTKdV/Xz+fFW+bDVWlyYIfaz89gnHfK5k4p/j/jRthw==
X-Received: by 2002:aa7:da82:0:b0:502:100c:53a with SMTP id q2-20020aa7da82000000b00502100c053amr30460055eds.41.1680353616865;
        Sat, 01 Apr 2023 05:53:36 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id b17-20020a50b411000000b004bf7905559asm2093952edh.44.2023.04.01.05.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 05:53:36 -0700 (PDT)
Date:   Sat, 1 Apr 2023 14:53:35 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH RFC v6 6/6] ptp_ocp: implement DPLL ops
Message-ID: <ZCgpTyHPu9Cz/XiA@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-7-vadfed@meta.com>
 <ZBBG2xRhLOIPMD0+@nanopsycho>
 <d192e0ac-3fa3-c799-ac93-84a17e6f6d50@linux.dev>
 <ZBG5CpF/o2wZkgSX@nanopsycho>
 <c8638e7a-5107-9a66-6725-0f087f834c46@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8638e7a-5107-9a66-6725-0f087f834c46@linux.dev>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Apr 01, 2023 at 01:28:29AM CEST, vadim.fedorenko@linux.dev wrote:
>On 15.03.2023 12:24, Jiri Pirko wrote:
>> Wed, Mar 15, 2023 at 01:10:33AM CET, vadim.fedorenko@linux.dev wrote:
>> > On 14/03/2023 10:05, Jiri Pirko wrote:
>> > > Sun, Mar 12, 2023 at 03:28:07AM CET, vadfed@meta.com wrote:

[...]


>> > > > +static int ptp_ocp_dpll_pin_to_sma(const struct ptp_ocp *bp, const struct dpll_pin *pin)
>> > > > +{
>> > > > +	int i;
>> > > > +
>> > > > +	for (i = 0; i < 4; i++) {
>> > > > +		if (bp->sma[i].dpll_pin == pin)
>> > > > +			return i;
>> > > 
>> > > Just pass &bp->sma[i] as a priv to dpll_pin_register().
>> > > and get that pointer directly in pin ops. No need for lookup and use of
>> > > sma_nr at all.
>> > 
>> > I'm still thinking about the change that you proposed to remove these
>> > _priv() helpers. I have to look into ice code to be sure we won't break
>> > any assumptions in it with moving to additional (void *) parameter.
>> 
>> There are basically 2 ways:
>> someop(struct subsystemobj *x, void *priv)
>> {
>> 	struct *mine = priv;
>> }
>> or:
>> someop(struct subsystemobj *x)
>> {
>> 	struct *mine = subsystem_get_priv(x);
>> }
>> 
>> Both are more or less equal. The first has benefit that the caller most
>> usually has direct access to the priv, so it can just easily pass it on.
>> Also, you as the driver write see right away there is a priv arg and
>> makes you want to use it and not figure out odd lookups to get to the
>> same priv.
>
>Thinking about this part. We have tons of parameters for some ops already.
>Adding void *priv to every one of them (and actually two for pins) makes them
>even more ugly. Let's stay with helpers if you don't have strong opinion
>against.

Well, with the patches I sent when 1 device/pin can be registered
multiple times with multiple privs, I believe it is much more feasable
to just pass the priv along in the arg list, because otherwise you would
have to do some odd lookup.

Please pass priv, would be nicer and easier and more simple for the
driver to implement. The arg list can handle that easily.

[...]
