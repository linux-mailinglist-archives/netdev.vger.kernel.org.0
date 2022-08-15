Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB4C594C5F
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 03:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240983AbiHPArF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 20:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349653AbiHPAqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 20:46:42 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D84D87F6;
        Mon, 15 Aug 2022 13:45:04 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ha11so7925146pjb.2;
        Mon, 15 Aug 2022 13:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=XS5K4OzaHR63BIa1xws9D0ReOq3Svv2Wh4Lbm5YbAfM=;
        b=POQ4Lda376BXN0B9b1jtVn5dk06uCU+dpZ0TVOwcNXMKz4thbYFRfKcbTZRu413o8T
         joeFgGN35weFYtqnpQK0bxOorsyX2IoaQh8HFvWBT/pU8Rgg6U19N8K63aJ5xdrVPx1e
         SAUAQ3qOPpIMIzPMdtk3n3Dpv7rKWuDRvcnWMTOxAFeiGUd39rD3fkovoFIg4QpAbLSb
         xzyyCNrPDZsmdqII7ChdtrONVxQiXbqyAvjmUwRC/QwxbXSxSi93uZ690b4+QkfteDr/
         1wBzjH901vu1iRNR39joY4Mg6o1vDcJR3SEKW37tqYsqJbiCLvc+UZpiEZpzbrhcLKaM
         L38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=XS5K4OzaHR63BIa1xws9D0ReOq3Svv2Wh4Lbm5YbAfM=;
        b=nB5l36PIt7XEClDlGameqp/4JDCrkNci1d1Thl8yYGJGKnqxDhLSe3Ng1Cj6+w/yEN
         C7vLxIw8sChKdPWZYAA3io/lNg9ekpGIYmWv666FU+73crlsJ1J6iMA17zXIrcrSFvNY
         uLa4WXFpMl72W9A94ZBwc6xXicwqdXFl4p0S9YQsPNES4iF11UBywT9xaMtzBB6HnzYp
         cfyBBcGsIfTSdGdCCEKOmSswDg2umBrbA+qTETAydI2agOqrzDUOIIgAptRPwb1PJ9+X
         aFxhrRaIrpkRdyzXIwyP6yOvbQWW8e80zBmBj8yt8f2jGk5vrssiWV6LhZhT/FGY5Zfv
         wxYg==
X-Gm-Message-State: ACgBeo2VoytQoriU2gkA+6vpHbMjzv9nJ/nCdsqIeBuEDf8isrXHgTIk
        HN533OR/De3w625Uj6oYNQw=
X-Google-Smtp-Source: AA6agR5hpN5Jw5Lb8baKNCmKSASjXILStRaT2kte+VwGknYpI/t1N4jPKG7MFOa60MRd2+2GnQcNFg==
X-Received: by 2002:a17:902:720b:b0:16d:2c4c:b52a with SMTP id ba11-20020a170902720b00b0016d2c4cb52amr18276430plb.155.1660596304001;
        Mon, 15 Aug 2022 13:45:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y11-20020a17090322cb00b0016c40f8cb58sm7386806plg.81.2022.08.15.13.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 13:45:03 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 15 Aug 2022 13:45:02 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Andres Freund <andres@anarazel.de>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        c@redhat.com
Subject: Re: upstream kernel crashes
Message-ID: <20220815204502.GC509309@roeck-us.net>
References: <20220815013651.mrm7qgklk6sgpkbb@awork3.anarazel.de>
 <CAHk-=wikzU4402P-FpJRK_QwfVOS+t-3p1Wx5awGHTvr-s_0Ew@mail.gmail.com>
 <20220815071143.n2t5xsmifnigttq2@awork3.anarazel.de>
 <20220815034532-mutt-send-email-mst@kernel.org>
 <20220815081527.soikyi365azh5qpu@awork3.anarazel.de>
 <20220815042623-mutt-send-email-mst@kernel.org>
 <FCDC5DDE-3CDD-4B8A-916F-CA7D87B547CE@anarazel.de>
 <20220815113729-mutt-send-email-mst@kernel.org>
 <20220815164503.jsoezxcm6q4u2b6j@awork3.anarazel.de>
 <20220815124748-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815124748-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael,

On Mon, Aug 15, 2022 at 12:50:52PM -0400, Michael S. Tsirkin wrote:
[ ...]
> 
> Okay! And just to be 100% sure, can you try the following on top of 5.19:
> 

You should now be able to test any patches using the syzkaller
infrastructure. Pick any (or all) of the now-published syzkaller
reports from the linux-kernel mailing list, reply with:

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v5.19

and provide your patch as attachment.

Guenter
