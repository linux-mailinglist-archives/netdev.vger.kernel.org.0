Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C606484AD
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiLIPIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiLIPIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:08:23 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA9484B62;
        Fri,  9 Dec 2022 07:08:22 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id n21so12139986ejb.9;
        Fri, 09 Dec 2022 07:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v2VJkWbNKEh0A4pf7A2XrZCZejaLGhVFMMh2tfBWT6o=;
        b=qbfi5thYQ/mx3gcgLXPFAHEWM8nedH40N+dssqFBXaYO+2MkoUYvp38WYHxrFCpKeA
         kyzDs9geJbpWdCLgPQoRS0r9av3VvgvkHgrx5owyd4fQ+mzPJ8ggu/oaH3alILIkJzc8
         xOx27QOK+c98Wib5FJXLxOn2v05z9ZahMcDO2phIuVUjbScKUTmecSDW/d75cYFzWD4o
         eajoKJofwf66fi9/gEyaGu6I13yW85O7uhOoC15NB8tJufRkccp2S+lQNt66P0B7DTML
         PBOiQEp6+iuTWkjORcAuSfjFcJEm3I0KsJodWNZFaQBqCs7FIpl/nNDgGOCWNsRjvYiW
         JnmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v2VJkWbNKEh0A4pf7A2XrZCZejaLGhVFMMh2tfBWT6o=;
        b=Mv7QkYNI9eosQqAI51ZIcDXCxVdFMvkbnDxjOooFPZFi9gJqA7JOfvHScS4qnXLX2+
         VJqkcenfRSnbCWFbmzBvqBTlWe8Rt67ba3Inhln7I4kgFP/fAco5LtEYNrmM83eprwwh
         lgieMtFOBtalhDK8HbESutnkyWxqsKKAsiYq9xnsfPFoOkQKfE4HCSF2+iCvS/BxE2w3
         wyq+OfMKuzUMEXRxPcgw0d5wAS3c/+fzXOMqYbwIOLzfDaV/YfB+iWv3IJnj/kfzxCBy
         2zJeFDYU23IjTvQ5iLs0jDY7zT0z8/EuXjDke4l0TSkI7ErugRB8n3SdSwHBK7VzeCLu
         3nCg==
X-Gm-Message-State: ANoB5pncUEUiDVcqF+w2yi3kR+y66N9TYxxRMY/DDEYvr88VTvNvc9sh
        CTF2x9GqiiWvXofTOUzI5Ec=
X-Google-Smtp-Source: AA0mqf59hGRMLyRxYK10EkDpol7tNadH8V3oG8GbyYzT2eDw2lHZCpXdSQPtMvlcHMLHLYlyz3WMyQ==
X-Received: by 2002:a17:906:6c7:b0:78d:f455:b5dc with SMTP id v7-20020a17090606c700b0078df455b5dcmr4865255ejb.28.1670598500718;
        Fri, 09 Dec 2022 07:08:20 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id r17-20020a1709061bb100b007ae243c3f05sm632091ejg.189.2022.12.09.07.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 07:08:20 -0800 (PST)
Date:   Fri, 9 Dec 2022 17:08:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v3 09/13] net: dsa: microchip: ptp: move
 pdelay_rsp correction field to tail tag
Message-ID: <20221209150818.jmva3syosfxjigpg@skbuf>
References: <20221209072437.18373-1-arun.ramadoss@microchip.com>
 <20221209072437.18373-1-arun.ramadoss@microchip.com>
 <20221209072437.18373-10-arun.ramadoss@microchip.com>
 <20221209072437.18373-10-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209072437.18373-10-arun.ramadoss@microchip.com>
 <20221209072437.18373-10-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 12:54:33PM +0530, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> For PDelay_Resp messages we will likely have a negative value in the
> correction field. The switch hardware cannot correctly update such
> values (produces an off by one error in the UDP checksum), so it must be
> moved to the time stamp field in the tail tag. Format of the correction
> field is 48 bit ns + 16 bit fractional ns.  After updating the
> correction field, clone is no longer required hence it is freed.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>

Similar. This needs your sign off too.
