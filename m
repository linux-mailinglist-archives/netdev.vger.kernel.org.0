Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38245115C10
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 12:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfLGLo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 06:44:26 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42876 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfLGLo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 06:44:26 -0500
Received: by mail-lj1-f194.google.com with SMTP id e28so10444144ljo.9
        for <netdev@vger.kernel.org>; Sat, 07 Dec 2019 03:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=noLqQanQbnK+x5xF9NBNdaHzY6bHKm/YguNVSzLLRs8=;
        b=UgUf7w3Px2Ofpq8vNvIc+I5YbSVu5X+2Go381iL0MdD8lIlkb0koa4Htd8fUtlS3Td
         6yRp3yQwgzZRbaBg5A2zdDgmj8EO53X0lpaFbU+fdI6P0zKMFtVgiKTTGh89GOxwSKJz
         KGiz77uCnQamHdgxr8SNbtPaBr0VcPdkFsfKYv2BM84nA+coKjOq/9rRDyNISWw08fIT
         pz3AaMcx8noVyKPyhcvnoM9nKUqxmL7SbCwoo39A/IjIAYCows+Mzei71e63FTtDnh54
         6ZivZ98SI4K9Jy2VF7uFmmvjOI2Tp3JK8x24+z9kIKOZomGoZ7YG1uKGKtlXLH5qkw2k
         ZmIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=noLqQanQbnK+x5xF9NBNdaHzY6bHKm/YguNVSzLLRs8=;
        b=CEtPpvaVNTfb10UL6OPc7JU5gBRbj2rqG6yPHhZkt3dVrT1ryzr3h8aPRJL1XvC+qF
         h+wtJRlq4YHK54btncJBGXkwe0cbi6mJAhppUO3vChtODW9uBbbM2S0vI5ySUNdHyQ7j
         EH7MUrUQkqSUM4a6COAmLbCOdmwGGBqEatnuuDneLjAltb3iB/yrQonjXC1PYsJoWo+O
         mKYpd4ECKGqj3pziup43mhA21yrULobrJOPCGc4jH922nrNRoZsRS+81YUe1fTKhxCWg
         JaPrJFEg0K7w3FjC1oG4AiD3jaPJDICKbUMCAqD8qseo4CwOI4m9CgU5R7XeERc+ILz7
         3Z0w==
X-Gm-Message-State: APjAAAU3DRj6OAl0PKEh+UGfZ/ma2FPJ6l0cJ8uqOqmmvTCGS0t1GvVX
        hZlZDIRNdLIUfWb0K198uLClYA==
X-Google-Smtp-Source: APXvYqz1vqly73aDm5n3BQ+fXG4izYsrEDXRa3r9B77B0WQiDdrXAtIaboVrpAn4I9udYSXQ8jJL5g==
X-Received: by 2002:a2e:859a:: with SMTP id b26mr11402734lji.137.1575719063530;
        Sat, 07 Dec 2019 03:44:23 -0800 (PST)
Received: from khorivan (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id c189sm3761894lfg.75.2019.12.07.03.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2019 03:44:22 -0800 (PST)
Date:   Sat, 7 Dec 2019 13:44:20 +0200
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        nsekhar@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: ti: davinci_cpdma: fix warning "device
 driver frees DMA memory with different size"
Message-ID: <20191207114419.GA2798@khorivan>
Mail-Followup-To: Grygorii Strashko <grygorii.strashko@ti.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        nsekhar@ti.com, linux-kernel@vger.kernel.org
References: <20191204165029.9264-1-grygorii.strashko@ti.com>
 <20191204.123718.1152659362924451799.davem@davemloft.net>
 <0c6b88b2-31b1-11f0-7baa-1ecd5f4b6644@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0c6b88b2-31b1-11f0-7baa-1ecd5f4b6644@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 12:48:46PM +0200, Grygorii Strashko wrote:
>
>
>On 04/12/2019 22:37, David Miller wrote:
>>From: Grygorii Strashko <grygorii.strashko@ti.com>
>>Date: Wed, 4 Dec 2019 18:50:29 +0200
>>
>>>@@ -1018,7 +1018,7 @@ static int cpdma_chan_submit_si(struct submit_info *si)
>>>  	struct cpdma_chan		*chan = si->chan;
>>>  	struct cpdma_ctlr		*ctlr = chan->ctlr;
>>>  	int				len = si->len;
>>>-	int				swlen = len;
>>>+	int				swlen;
>>>  	struct cpdma_desc __iomem	*desc;
>>>  	dma_addr_t			buffer;
>>>  	u32				mode;
>>>@@ -1040,6 +1040,7 @@ static int cpdma_chan_submit_si(struct submit_info *si)
>>>  		chan->stats.runt_transmit_buff++;
>>>  	}
>>>+	swlen = len;
>>>  	mode = CPDMA_DESC_OWNER | CPDMA_DESC_SOP | CPDMA_DESC_EOP;
>>>  	cpdma_desc_to_port(chan, mode, si->directed);
>>>-- 
>>>2.17.1
>>>
>>
>>Now there is no reason to keep a separate swlen variable.
>>
>>The integral value is always consumed as the length before the descriptor bits
>>are added to it.
>>
>>Therefore you can just use 'len' everywhere in this function now.
>>
>
>Sry, but seems i can't, at least i can't just drop swlen.
>
>Below in this function:
>	writel_relaxed(0, &desc->hw_next);
>	writel_relaxed(buffer, &desc->hw_buffer);
>	writel_relaxed(len, &desc->hw_len);
>	writel_relaxed(mode | len, &desc->hw_mode);
>^^ here the "len" should be use
>
>	writel_relaxed((uintptr_t)si->token, &desc->sw_token);
>	writel_relaxed(buffer, &desc->sw_buffer);
>	writel_relaxed(swlen, &desc->sw_len);
>^^ and here "len"|CPDMA_DMA_EXT_MAP if (si->data_dma) [1]
>
>	desc_read(desc, sw_len);
>
>so additional if statement has to be added at [1] if "swlen" is dropped
>
>-- 
>Best regards,
>grygorii

Seems like yes,

And the "swlen" can be avoided like this:

--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -1018,7 +1018,6 @@ static int cpdma_chan_submit_si(struct submit_info *si)
        struct cpdma_chan               *chan = si->chan;
        struct cpdma_ctlr               *ctlr = chan->ctlr;
        int                             len = si->len;
-       int                             swlen = len;
        struct cpdma_desc __iomem       *desc;
        dma_addr_t                      buffer;
        u32                             mode;
@@ -1046,7 +1045,7 @@ static int cpdma_chan_submit_si(struct submit_info *si)
        if (si->data_dma) {
                buffer = si->data_dma;
                dma_sync_single_for_device(ctlr->dev, buffer, len, chan->dir);
-               swlen |= CPDMA_DMA_EXT_MAP;
+               writel_relaxed(len | CPDMA_DMA_EXT_MAP, &desc->sw_len);
        } else {
                buffer = dma_map_single(ctlr->dev, si->data_virt, len, chan->dir);
                ret = dma_mapping_error(ctlr->dev, buffer);
@@ -1054,6 +1053,7 @@ static int cpdma_chan_submit_si(struct submit_info *si)
                        cpdma_desc_free(ctlr->pool, desc, 1);
                        return -EINVAL;
                }
+               writel_relaxed(len, &desc->sw_len);
        }
 
        /* Relaxed IO accessors can be used here as there is read barrier
@@ -1065,7 +1065,6 @@ static int cpdma_chan_submit_si(struct submit_info *si)
        writel_relaxed(mode | len, &desc->hw_mode);
        writel_relaxed((uintptr_t)si->token, &desc->sw_token);
        writel_relaxed(buffer, &desc->sw_buffer);
-       writel_relaxed(swlen, &desc->sw_len);
        desc_read(desc, sw_len);
 
        __cpdma_chan_submit(chan, desc);

But not sure what is better.

-- 
Regards,
Ivan Khoronzhuk
