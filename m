Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD1D5BE4FE
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 13:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiITLxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 07:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiITLxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 07:53:41 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770B674B81
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 04:53:39 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id p5so2628343ljc.13
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 04:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=EC/x2/yPMBgPRBzElLyCJ1KJ3S64gBsW3wRwTRTyvo8=;
        b=F90qXRhhUBT83JwZCsvNloRPk3niYVA+avNTz9afAgswqeGGUtDh4Qtnm7xMBYQdlr
         DcINbrNLidtscWgOj+qpjXw7Lb3HCuDsccjiEvpmax4RQIJSA1CCsMJKA9TNXgufRYnm
         WxuBBW9MfZx+1Fx5FKdIJ0WQaETFUg4mcNKO41qxcrnbBNOikpmQXBLHidTDuAbxYx3u
         guOsH/YFk4/M/GDcJYZRnGoYtc2roZ2PEkd4EvnVutVJh+BcVoTk72rqEh/TGnybSPEw
         5ZB0ciSkXpNqNYFVpgTg1CvOk4GrnQO3yuvZrJijx9fld3QRMKL03hyL9927JdSv+bcb
         lTsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=EC/x2/yPMBgPRBzElLyCJ1KJ3S64gBsW3wRwTRTyvo8=;
        b=OoiOt+dwMdQZTVVw75ZamMntrlxwfG54R9PPYTPV8W/6pB33QAJ/aL1qBnp+RUXtDK
         uFkRK4G9UPk9AunVMZJtAER3oq0HhrTb6/Yjx8ls7eEacXxE+AiIZkxE62vISx/f2Lh/
         06hk9/c/tOYCcemOo53qKJvuFG55kO3T095b1+/DlElWziLgwH2zZrB6IVnhulGYGdhB
         mxoRLWredytBcsuZjdQOiqwAv1AvcmKBzp7ZGCBc5W4xlFj5Hhxfa/wP368s1qBngVex
         4nHeCMXyGyPVNTqby6gsIsKMUwtG1hDCrTH5xsgEi9w/ctAmXVQPj0M6GGb0sNIW6szs
         0t9w==
X-Gm-Message-State: ACrzQf1105P6YtEz1w5JH2Ylp1PEMzpsbv6XJAqM0Jmn1gkHcnLO9wwi
        rj+9f+WVHRl95LbVF5Rm4Dd75km7ZQZuCw==
X-Google-Smtp-Source: AMsMyM5lhO83Jg0XztLo3N+ZsxSI80ojq1Z3wGoFNFaAZHdCEYVNW/tqaanm5lFaLP28SfP+jzNfUg==
X-Received: by 2002:a05:651c:101:b0:250:896d:f870 with SMTP id a1-20020a05651c010100b00250896df870mr7397431ljb.235.1663674817722;
        Tue, 20 Sep 2022 04:53:37 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id h18-20020a05651c125200b0026bdb7ad643sm235510ljh.50.2022.09.20.04.53.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 04:53:37 -0700 (PDT)
Message-ID: <2be57208-61fe-95f6-f70a-b3a86f5024a1@gmail.com>
Date:   Tue, 20 Sep 2022 13:53:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v14 4/7] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-5-mattias.forsblad@gmail.com>
 <20220919110847.744712-5-mattias.forsblad@gmail.com>
 <20220919223933.2hh4hhci3pj33lrj@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220919223933.2hh4hhci3pj33lrj@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-20 00:39, Vladimir Oltean wrote:
>> +void mv88e6xxx_master_state_change(struct dsa_switch *ds, const struct net_device *master,
>> +				   bool operational)
>> +{
>> +	struct dsa_port *cpu_dp = master->dsa_ptr;
>> +	struct mv88e6xxx_chip *chip = ds->priv;
>> +	int port;
>> +	int ret;
>> +
>> +	port = dsa_towards_port(ds, cpu_dp->ds->index, cpu_dp->index);
>> +
>> +	mv88e6xxx_reg_lock(chip);
>> +
>> +	if (operational && chip->info->ops->rmu_enable) {
> 
> This all needs to be rewritten. Like here, if the master is operational
> but the chip->info->ops->rmu_enable method is not populated, you call
> mv88e6xxx_disable_rmu(). Why?
>

So what should we do in this case? If the master is operational but we cannot
enable rmu (bc no funcptr), we cannot use RMU -> disable RMU.

/Mattias

>> +		ret = chip->info->ops->rmu_enable(chip, port);
>> +
>> +		if (ret == -EOPNOTSUPP)
>> +			goto out;
>> +
>> +		if (!ret) {
>> +			dev_dbg(chip->dev, "RMU: Enabled on port %d", port);
>> +
>> +			ret = mv88e6xxx_enable_check_rmu(master, chip, port);
>> +			if (!ret)
>> +				goto out;
