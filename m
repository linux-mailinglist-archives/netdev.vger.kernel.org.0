Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 461F311DCFC
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 05:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732051AbfLMELg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 23:11:36 -0500
Received: from mail-ot1-f53.google.com ([209.85.210.53]:43083 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732042AbfLMELe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 23:11:34 -0500
Received: by mail-ot1-f53.google.com with SMTP id p8so4649434oth.10
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 20:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xLM1UQFYYcAwjm3AkxL/XObitZ0sAOLzQkwkZFwVx3A=;
        b=JJt9+r0W1EwucVyoKjZpsUZy1JY6gR1XEQUvGW0/M4ohjfR+JcTwijOrI3FfFIu+If
         uPJJbHZfU7tuNkyZsGSUnfzzJV/qjFPopmpdHrGAGSNDp7rLlAmNEfF8CfZI1332F9gY
         d3ClRJSG5sp7htcYeCBakwy8N3W+Pme/pcbCQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xLM1UQFYYcAwjm3AkxL/XObitZ0sAOLzQkwkZFwVx3A=;
        b=ZSafh9DrFaiMDvXegNNmTrS71B2MXBjI2NTcGo6lQ4oad152jRixKu54bKXRC3/m2b
         PwMdWEWRtIPrxeF+a2iIRuUGxaBDVk09s+nPY0EeZUbJs12Eek1bIaCaRoWe6IE0j1nG
         ERO77wX1FK0Gky1XU6fnFO1XIr0ejtgGFa23iCmJD6InEM5QQ4Iz+PDNkjXlXUm3bZS9
         ylZ4V7Own49OOoxjzH0AabZmbMYAhqYXDWwVFjys/EjgU47Zt0MS7dDPi06lsd4vC9Cr
         6VMrRcT9YAIiZn8zZbaevtowk70KDjK+0c69y6CbX+8F/9c58t9S/mHYOxQjZz38ybNX
         Tdsg==
X-Gm-Message-State: APjAAAX/F89ROSAJX+YOq5bt1cFkKDTKfXuBXol8hJwkc8cVgM7378zL
        F3sOiTugk8IGLNsH1pdp6jDr5CGk/wCxXL5f7YtFKA==
X-Google-Smtp-Source: APXvYqzNd4TzlE+88NZC9nxKeVIkHDzlTzUiD1HAvCd6oGZMmbaD9eWf49oiydCIT+m03sjjqkr84m7kMICXVqZ46Tc=
X-Received: by 2002:a9d:6c06:: with SMTP id f6mr12593659otq.318.1576210294020;
 Thu, 12 Dec 2019 20:11:34 -0800 (PST)
MIME-Version: 1.0
References: <DM6PR18MB338861990B56CCA5A4384779AB540@DM6PR18MB3388.namprd18.prod.outlook.com>
In-Reply-To: <DM6PR18MB338861990B56CCA5A4384779AB540@DM6PR18MB3388.namprd18.prod.outlook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 12 Dec 2019 20:11:23 -0800
Message-ID: <CACKFLi=30KJXL0xbdfgYqxWML5C5ZWyDPjtATByVf7hsao9gZQ@mail.gmail.com>
Subject: Re: LRO/HW_GRO is not disabled when native xdp is installed
To:     Manish Chopra <manishc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 7:13 PM Manish Chopra <manishc@marvell.com> wrote:

> When attaching native xdp program, device's aggregation features (i.e LRO/HW_GRO) are not getting disabled.
> They seems to be getting disabled only in case of generic xdp install, not in case of native/driver mode xdp,

That sounds right.  For bnxt, when an xdp program is attached, the
driver will run in a special paging mode that won't support LRO or
hardware GRO.  So they are automatically turned off.  Isn't that the
case for your device as well?
