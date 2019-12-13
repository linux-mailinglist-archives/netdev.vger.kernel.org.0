Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B118311ECA6
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 22:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfLMVJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 16:09:44 -0500
Received: from mail-oi1-f174.google.com ([209.85.167.174]:36196 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfLMVJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 16:09:44 -0500
Received: by mail-oi1-f174.google.com with SMTP id c16so1152087oic.3
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 13:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xyhx+OWGhxqxGsbk8K4DuP/n1j7ZCw2vNhkuXi7zJrE=;
        b=hU0R/3Oaoax1sm6lAlxWHFki5O1aUoliFkjjk1mkTFMoTDEROICC1TuRZSzOZL+0JN
         gPjLqkJOFUfOdjlowZVhI+IruHeAtt8xgwSOg+skmPBStfANs9XWwpjQACu/7K9Z6Y7P
         gkCbF0CMG3pTLNIkQgNpdFFGP17xN4mmrjyvY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xyhx+OWGhxqxGsbk8K4DuP/n1j7ZCw2vNhkuXi7zJrE=;
        b=BrfLThS1v2Wd1fG0M7tqXHCkJ5ACQivCDawsaBOcqa9ITF08pJJilew4LnsSvS16HC
         g8axKw7sWOraYG9Qewb4X98qradiAE2b4yR6RFW2NNPdTs4Di4+zfBgyQuC6HO+D7N8O
         Z1MOEKXpr53nyqHQntP8vbmIou6NKb/EqMSEZba201XBXfcBz9LcQI0GAQYO1PSeDKcx
         whmqDgZFyuNoPLCyt/dmE+7Vos3XPL9PrV4RSvCAixGAhsl4sdhLkcpnUX3n5CbfVt5L
         vkpDSKOzsqL2xLM5CVfHAz1IJR7Q6vvQVxUqGa8KKJMRQrayYEB4ksqBJumbTXhYD2HV
         nPjw==
X-Gm-Message-State: APjAAAX2Ju/N7JUxS83/UzX5wg+1qcq8/V1ogguVtY3YfbUTa9WbYcvC
        6vjgYBwB/Jz7XaZ+d8BFoAY+wkOREMaenUHpWkVHQ8Uz
X-Google-Smtp-Source: APXvYqyjlgc+CwkEPwvDviRIoisfIzaRx5wPuGQoefsX36OfUqTy/rQqfEfrNmq2onP6grR7Udn3N14C1GEDP7oWMIk=
X-Received: by 2002:a05:6808:3ca:: with SMTP id o10mr7537000oie.14.1576271383076;
 Fri, 13 Dec 2019 13:09:43 -0800 (PST)
MIME-Version: 1.0
References: <DM6PR18MB338861990B56CCA5A4384779AB540@DM6PR18MB3388.namprd18.prod.outlook.com>
 <CACKFLi=30KJXL0xbdfgYqxWML5C5ZWyDPjtATByVf7hsao9gZQ@mail.gmail.com> <BY5PR18MB3379AC23267423E0CE9EEA05AB540@BY5PR18MB3379.namprd18.prod.outlook.com>
In-Reply-To: <BY5PR18MB3379AC23267423E0CE9EEA05AB540@BY5PR18MB3379.namprd18.prod.outlook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 13 Dec 2019 13:09:31 -0800
Message-ID: <CACKFLin=JS-5mou=0-b9nvHh=4=9AopZUDGLb+ZkkVYbAsk3WQ@mail.gmail.com>
Subject: Re: [EXT] Re: LRO/HW_GRO is not disabled when native xdp is installed
To:     Manish Chopra <manishc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 1:45 AM Manish Chopra <manishc@marvell.com> wrote:

> It used to be the case for our devices as well long back. but after the commit 18c602dee4726 ("qede: Use NETIF_F_GRO_HW")
> that part was removed from our driver and commit 56f5aa77cdad1 ("net: Disable GRO_HW when generic XDP is installed on a device")
> was added to achieve the same instead of individual driver doing it, but it wasn't caught that time why later commit only does for generic xdp,
> not for native xdp. So today when native xdp is attached to our device, HW GRO aggregation remains enabled on our device.
> Please let me know if that fix is good enough to be posted. Will test it out and post.
>

The driver knows when an xdp program is attached and can disable any
features that are not compatible, so I think it is more efficient to
keep it this way.  Generic XDP on the other hand, does not involve the
driver and so we need to disable them for the driver.
