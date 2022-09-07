Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A605AFC0A
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 07:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiIGFzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 01:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIGFzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 01:55:36 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4403D7E30A
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 22:55:35 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id q21so6545072lfo.0
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 22:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=5almE6ImzSmH80WjtdV+eVDLPgneSf3lIMsEkZtIVOE=;
        b=nz+xWrO3nsOvWUEErCQSeLgqFjtCGuQdr39ZIiRG0klliMf3rxr426Nf1UUk8eTwka
         92EcUUu25R8XBbTvziFlBPisXE+OQVmG/iaMbezf31IunZhUNdpJq1cvvXay0UgQhpHg
         N20ha5YVcUoE+wXDLh6mWcNozrw0vl0v04BZeU5GP/BzPRhO50L1uG3p+Sc7b48PDQa7
         wGQYVdshW4zmlZFzr1RJjAioUqLiR0Hye+AbFy8iw9ct/Q3tEtepNPky0/M3KznL6c6f
         foxoyr+PGGEhAqXJ9t2RxRVWF8CfYj/F+6qJEQjaV+mtoahrXDJg0Pp6IDqw81XwcLCT
         eSGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=5almE6ImzSmH80WjtdV+eVDLPgneSf3lIMsEkZtIVOE=;
        b=B/vwzymSzHPmmBWUVjphqVB0JT183bky7LIHDCTUvuvCoVCCUXR36H7b0RGPrC1Jt1
         snzSrnn4G0YkPHoBQX5cYaKH0oepj0yaOHOcox1MsFv6c8BXlgpmpU9os8wuqnsIT+Gn
         OZDK4+oub/6ZaIHUK8fs2rsxKIHn/g0zQ7jrCQndcmV62sl9NgkqEmhRg68+TOVKm0Ht
         WSs0ropUubWgjElc8ELsMY+i8ftYEk3nxYmI88a5bOGaFpf+g499AFpqtyQgbA4oBeSf
         xv2JigYhPjaR5Z8wqA+4Gza+ec9HF3PzXQ/iCiEGfLkVxOxdQcSgEnrK/hsVrcQMpcEK
         DUpg==
X-Gm-Message-State: ACgBeo2SjHoJ1h08q/U7/QGPTSCOrgOWuMZCioRvcbkrzvMMb25k35ju
        pQzVn+zMe/8axA2dNjqHheFUzCG9OaeLhE/o
X-Google-Smtp-Source: AA6agR7XwvkdFsFl9xKj/XoCm0pRPR27/zZtZhwp4mQ/8xI8BWr8xjx25H3/ra2up8qMOlVZYnNlLg==
X-Received: by 2002:a19:2d0d:0:b0:491:63c9:5a5f with SMTP id k13-20020a192d0d000000b0049163c95a5fmr528475lfj.629.1662530133401;
        Tue, 06 Sep 2022 22:55:33 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id w10-20020a05651234ca00b00492c5ec6f84sm2223465lfr.249.2022.09.06.22.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 22:55:33 -0700 (PDT)
Message-ID: <21083a2e-4c3c-26ff-0399-0446a3cab85c@gmail.com>
Date:   Wed, 7 Sep 2022 07:55:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 1/6] net: dsa: mv88e6xxx: Add RMU enable for
 select switches.
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
 <20220906063450.3698671-2-mattias.forsblad@gmail.com>
 <Yxc9MjVI+afjcNcp@lunn.ch>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <Yxc9MjVI+afjcNcp@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-06 14:29, Andrew Lunn wrote:
>> +int mv88e6085_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port)
>> +{
>> +	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
>> +
>> +	dev_dbg(chip->dev, "RMU: Enabling on port %d", upstream_port);
>> +
>> +	switch (upstream_port) {
> 
>>  
>> +int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port)
>> +{
>> +	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
>> +	int upstream_port;
>> +
>> +	upstream_port = dsa_switch_upstream_port(chip->ds);
>> +	dev_dbg(chip->dev, "RMU: Enabling on port %d", upstream_port);
>> +	if (upstream_port < 0)
>> +		return -EOPNOTSUPP;
>> +
>> +	switch (upstream_port) {
> 
>> +int mv88e6390_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port)
>> +{
>> +	int val = MV88E6390_G1_CTL2_RMU_MODE_DISABLED;
>> +
>> +	dev_dbg(chip->dev, "RMU: Enabling on port %d", upstream_port);
>> +
>> +	switch (upstream_port) {
> 
> 
> Why is 6352 different to 6085 and 6390? This is the sort of thing
> which should be explained in the commit message. The commit message is
> about the 'Why?' of the change. You could explain why there is this
> difference, so a reviewer does not need to ask.
> 
> 	    Andrew

I'm sorry, I must have slipped on the keyboard :/ It should be similar for
all functions. I'll fix that.

	Mattias
