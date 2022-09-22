Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBD85E6E63
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiIVV0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiIVVZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:25:58 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA55CEBBDA
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:25:57 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id z9so7767048qvn.9
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=pYwmdnyRRaPGkritobnppBlsSufNAop0K6wOxs5y5JE=;
        b=BUHslaofrX1u2VXB5d3s45QpwPl/DDSRgncfCsBa+ICTqA7AYEme8D8VpO66RHMo5h
         i6VomhKKjKgtlQkLwkPRIIzMR2BffFGwEGIw4+ym0iAFUSCv9jAMLsA0DEUI6yv1DhB+
         /EsVsec7f4zWpol0I+7Z+o3syRfrz0YDy3265d+3vmsF7g+7LHh+dMA1yxPaHs1ZxDDJ
         ybSAB8i4z8zaBhUYJ74D303N8K0LLCIbZJ8Pfn8Jeie8xOfSCzpnOu+uUnEDdwb/a2Js
         lECzx2irvtbAlr9Jl/MMOUmVBOda2+2N2Xw2Hsi7T/hh4NfUFMhNgr1sYAui7rm/IMdB
         DZdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=pYwmdnyRRaPGkritobnppBlsSufNAop0K6wOxs5y5JE=;
        b=gWqsdpm/dJminDELSw9mpCKupTI5NLD5hRquJHnGd2wjWOB64N7u9liupxEaOxuFlL
         ao3GLLlDTiUnBsxjOWfmXLFIoDmhwZvpVNNzwjFw36NIzaVDJRBMRWKbFucT8X/0yLs2
         Ny4eKOJVrqeZqrdC6O8eLDcQ7xJ0WnhgbGdDcyAsr2Q+gcYPfEnfLgLzLffJXigCJrGm
         NoH2UpEA/QO/fG5EvoYMAMEcdzMWNvFk4BGAXTGNecMfh5AQYP3R/ob8Z/F8SARNFxR7
         QxNe/A/h1j6yJffOddnkJyN23YYkKLlIxF6n93f+DAk9axzdT5gO9pT9maW0zPJryrAG
         hh4A==
X-Gm-Message-State: ACrzQf23d9wTwW96Xz1ebgEiNPBJYHSamHTC5FkXN4SAVsfpA1Nr6txE
        U6myEtBJKluUgiSX+0n4cPM=
X-Google-Smtp-Source: AMsMyM6Td68tNMIiC3P31NLW884UIb8lyXrzRllSxv+Jpvt1jpzjRtOTDFJiplUO+QIPbWTETvONHQ==
X-Received: by 2002:a05:6214:4112:b0:4ac:6d95:1037 with SMTP id kc18-20020a056214411200b004ac6d951037mr4328113qvb.14.1663881956806;
        Thu, 22 Sep 2022 14:25:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t14-20020a05620a450e00b006cbcdc6efedsm4667422qkp.41.2022.09.22.14.25.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 14:25:56 -0700 (PDT)
Message-ID: <862fa246-287f-519e-f537-fff85642fb15@gmail.com>
Date:   Thu, 22 Sep 2022 14:25:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
 <20220921113637.73a2f383@hermes.local>
 <20220921183827.gkmzula73qr4afwg@skbuf>
 <20220921153349.0519c35d@hermes.local>
 <20220922144123.5z3wib5apai462q7@skbuf> <YyyCgQMTaXf9PXf9@lunn.ch>
 <20220922184350.4whk4hpbtm4vikb4@skbuf>
 <20220922120449.4c9bb268@hermes.local>
 <20220922193648.5pt4w7vt4ucw3ubb@skbuf> <YyzGvyWHq+aV+RBP@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YyzGvyWHq+aV+RBP@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/22 13:34, Andrew Lunn wrote:
>> Ok, if there aren't any objections, I will propose a v3 in 30 minutes or
>> so, with 'conduit' being the primary iproute2 keyword and 'master'
>> defined in the man page as a synonym for it, and the ip-link program
>> printing just 'conduit' in the help text but parsing both, and printing
>> just 'conduit' in the json output.
> 
> Sounds good to me.

Works for me as well! Thanks Vladimir.
-- 
Florian
