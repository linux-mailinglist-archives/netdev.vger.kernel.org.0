Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76994620C79
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbiKHJke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbiKHJk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:40:28 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C82727900;
        Tue,  8 Nov 2022 01:40:22 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r14so21569341edc.7;
        Tue, 08 Nov 2022 01:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6R2u+4ncSx8KluFMuPj2ehi9rZ//rxoPRpAs8tI9poY=;
        b=Fnn44XdkufgkSSnM4GLF7F4kNg8m/N+jGANKbUq2WAeEQ7iLvra2UN1+f0e8nLnC6e
         gYz1xNnUUJaZtY0nTH2M5LgFsJwj/6bh2xhRT3qYbkwZHRv3CJ76Cao3yhUDDDR4QuyK
         1Gbq4L4pmDznRj/9KTV4z52/0+s3RV1iBnGudg8WXAJAtz6a/7JOxUaWsYg9prNphWih
         cR1gP8aQF6xu0jTpTHjhRSB+goaCNvk4K1A/HHpzyKCTuyR1RxypYFw9t8XQYZpuiaeY
         nzXeWiRGQU8DnwhmzKN9D5blcKfqEQ8NctWarfkSXleA17D6rW76gj1flLM9A9rUdEzs
         hu+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6R2u+4ncSx8KluFMuPj2ehi9rZ//rxoPRpAs8tI9poY=;
        b=G+f8FQ0zrRAJps2ZJVBw8QnpJL7iKlGWIvP9yPRFuVRL/fJa3wLTDqkojj+nZfHXTn
         O5+8h6/JOkDiF8YX7yCLKN5ls4JCz/C/Z27Omlm3lGb5GSPw9KRR7TbLYI8T2UJh4CJC
         gyHrp1drj93sMbvXddUMYFgHWhkzg9egdzJGJ+fCNGL99VGd2pIFrHOtcAzKgWS0h250
         AjxmTsTW8KU7vENena/IWFzp3cdSeu3G4+MWuoVyO6CphapzY2NvZhmEMDrjIsUInjdf
         FT0S0CmVLQPbmzToS7Atqz4yNp+aPyG6dvhCqBKgMU/emC7XXDu7f74jdykH55T4NrUe
         4/hw==
X-Gm-Message-State: ANoB5plmOYsFxCrBIpxCduNiecOdLNwo6sXMOmCKiKNQ1KA4mYbFlDzO
        cHgGpYracCL5mK+5fK7ttc4CZCZdkaxF+w==
X-Google-Smtp-Source: AA0mqf7femjNdGyEnapokREP6cqG8YFp2Vsz0oKrp/hKd997QAkd5iA8xAGiLc/EhnFHTq4mjynVzw==
X-Received: by 2002:a05:6402:27d2:b0:462:8e41:569c with SMTP id c18-20020a05640227d200b004628e41569cmr13648250ede.191.1667900420657;
        Tue, 08 Nov 2022 01:40:20 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id hg11-20020a1709072ccb00b007a8de84ce36sm4392806ejc.206.2022.11.08.01.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 01:40:20 -0800 (PST)
Date:   Tue, 8 Nov 2022 11:40:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] net: vlan: remove invalid VLAN protocol warning
Message-ID: <20221108094018.6cspe3mkh3hakxpd@skbuf>
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-8-nbd@nbd.name>
 <20221107215745.ascdvnxqrbw4meuv@skbuf>
 <3b275dda-39ac-282d-8a46-d3a95fdfc766@nbd.name>
 <20221108090039.imamht5iyh2bbbnl@skbuf>
 <0948d841-b0eb-8281-455a-92f44586e0c0@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0948d841-b0eb-8281-455a-92f44586e0c0@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 10:20:44AM +0100, Felix Fietkau wrote:
> I need to look into how METADATA_HW_PORT_MUX works, but I think it could
> work.

Could you please coordinate with Maxime to come up with something
common? Currently he proposes a generic "oob" tagger, while you propose
that we stay with the "mtk"/"qca" taggers, but they are taught to look
after offloaded metadata rather than in the packet. IMO your proposal
sounds better; the name of the tagging protocol is already exposed to
user space via /sys/class/net/<dsa-master>/dsa/tagging and therefore ABI.
It's just that we need a way to figure out how to make the flow
dissector and other layers not adjust for DSA header length if the DSA
tag is offloaded and not present in the packet.
