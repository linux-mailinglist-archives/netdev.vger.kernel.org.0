Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF1959F1EA
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 05:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiHXDUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 23:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiHXDU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 23:20:26 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840467E319
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 20:20:24 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id l64so13923996pge.0
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 20:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc;
        bh=Tpi/aztaevRXhD7hpGo9AB7PidGdRBw6bYsB56/l300=;
        b=XB6y04ENo8HvQCjVqSTd7albmZTzNDOvZK6dd56WyIUeY6UPgQ+li2B2/rjnF1Wb5R
         iSd0brtowuURBN9eQltZvhyWLXSO0bezLIWJ10amlYxmY1lxdA/CXjEZtLyJmJZN2KSb
         uVYvSzZAHmSk5ITgHcjd1Jy9LT56JLhxgkw+Ttcu92fLjE2cE6YPBOR765ZAdzQtrUUz
         ZeG8g+WrjuUVW7T7PNaJ05pGlFDsAAgXEYmX0y+IijBrfjnGn/HXNmvuPsUTGlM8LeTJ
         6hL5hqyDQpvzvuCr+Y0wvC+FhcPAgkbgSa+MQ/DZRMy/q3FAz5Zn0dxRu1fN0GL2jSF2
         IfsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=Tpi/aztaevRXhD7hpGo9AB7PidGdRBw6bYsB56/l300=;
        b=OraE2Uc4SkbmWJGfdHjB5oTvxOKKjN96MnDGc/aaEppm10MdQS0V5kr21xhOFrfvMF
         jLpPr/5890iSENzi882CSaR51Kd63yMrUbCAIERdEl2gzzqAYepX8yM2b8UdAI2xrrMm
         EKnExOoaDMhhtA9QQ6gix36YjbsfuY6qbQ4kAqB7uDkjTj58wS1OIuVVj4r7v871lxde
         rP4emPJ9MiFrthjCdewxs6GZ/bOMMan2AZRFb5cl+ZOm6tkUvK78WJWoEB0fm3O9LO/V
         tA1/Cn66IBU21W5tasbsAlSgmpcEKIx8G4pEapaCM5hJsr6AeRrzXuICRjI8ZD8omILn
         zusQ==
X-Gm-Message-State: ACgBeo3HR9dfWp5LN+LmujA0Yvph6a8L0yCcx1K5vqaSiP4Ok+LKPl/Q
        KKbEkJMjS47mnxSooURAM5e3xTIeHSvk5g==
X-Google-Smtp-Source: AA6agR7AMr/bgz1PhIIsUZbSXs81IoupTfviiyC7K55cuPGqDxEjgc3Q528MF6C4osD9ODAp8cRxWg==
X-Received: by 2002:a63:1265:0:b0:41d:a571:2805 with SMTP id 37-20020a631265000000b0041da5712805mr22776158pgs.230.1661311223731;
        Tue, 23 Aug 2022 20:20:23 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id iw3-20020a170903044300b00172709064besm11237792plb.46.2022.08.23.20.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 20:20:23 -0700 (PDT)
Date:   Wed, 24 Aug 2022 11:20:18 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Arkadi Sharshevsky <arkadis@mellanox.com>
Subject: [Question] Should NLMSG_DONE has flag NLM_F_MULTI?
Message-ID: <YwWY8ux/PyMWQBWr@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When checking the NLMSG_DONE message in kernel, I saw lot of functions would
set NLM_F_MULTI flag. e.g. netlink_dump_done(),
devlink_dpipe_{tables, entries, headers}_fill().

But from rfc3549[1]:

   [...] For multipart
   messages, the first and all following headers have the NLM_F_MULTI
   Netlink header flag set, except for the last header which has the
   Netlink header type NLMSG_DONE.

What I understand is the last nlmsghdr(NLMSG_DONE message) doesn't need to
have NLM_F_MULTI flag. Am I missing something?

[1] https://www.rfc-editor.org/rfc/rfc3549.html#section-2.3.2

Thanks
Hangbin
